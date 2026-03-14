#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Mapa de localização do Território Semiárido Nordeste II com imagem de satélite
e destaque para as comunidades quilombolas de Jeremoabo – BA.

Layout multi-painel (estilo artigo científico):
  - Coluna esquerda: (a) Brasil → Bahia, (b) Bahia → Jeremoabo
  - Painel principal: imagem de satélite (Esri World Imagery) com marcadores
    das 11 comunidades quilombolas certificadas pela FCP/INCRA.

Autor : Luiz Diego Vidal Santos
Instituição: PPGPI / UFS
Data  : 2025-03-13
Licença: CC-BY-4.0

Dependências: geopandas, geobr, contextily, matplotlib, pyproj
"""
import warnings
from pathlib import Path

import matplotlib
matplotlib.use('Agg')

import contextily as ctx
import geopandas as gpd
import geobr
import matplotlib.pyplot as plt
import matplotlib.patheffects as pe
from matplotlib.gridspec import GridSpec
from matplotlib.lines import Line2D
from matplotlib.patches import Patch
from pyproj import Transformer

warnings.filterwarnings('ignore')

# ── Configurações visuais ─────────────────────────────────────────────
plt.rcParams.update({
    'font.family':   'sans-serif',
    'font.sans-serif': ['Arial', 'DejaVu Sans'],
    'font.size':      10,
    'figure.dpi':    300,
})

# ── Diretórios ────────────────────────────────────────────────────────
BASE_DIR    = Path(__file__).parent.parent.parent
FIGURAS_DIR = BASE_DIR / '3-APRESENTACAO' / 'assets'
OUTPUT_DIR  = Path(__file__).parent
FIGURAS_DIR.mkdir(parents=True, exist_ok=True)
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

# ── Coordenadas das 11 comunidades quilombolas (IBGE, 2019) ──────────
# Fonte: Base de Informações sobre Localidades Quilombolas – IBGE
# Município de Jeremoabo – BA (IBGE 2922003)
COMUNIDADES = {
    'Algodões':              (-10.0800, -38.5650),
    'Algodões dos Negros':   (-10.0950, -38.5800),
    'Angico':                (-10.0100, -38.4400),
    'Ariade':                (-10.0400, -38.5100),
    'Baixão da Tranqueira':  (-10.1500, -38.6000),
    'Baixão da Viração':     (-10.1650, -38.5500),
    'Casinhas':              (-10.1100, -38.5300),
    'Olho D\'Água':          (-10.0000, -38.4000),
    'Olho D\'Água dos Negros': (-9.9800, -38.3800),
    'Vasos do Ouricuri':     (-10.2000, -38.6200),
    'Viração':               (-10.1800, -38.5700),
}

# Sede municipal de Jeremoabo
SEDE_JEREMOABO = (-10.0681, -38.3481)

# ── Helpers ───────────────────────────────────────────────────────────

def add_north_arrow(ax, x, y, size=0.03):
    """Agulha de bússola em coordenadas axes."""
    left_x  = [x, x - size * 0.6, x]
    left_y  = [y + size, y, y - size]
    right_x = [x, x + size * 0.6, x]
    right_y = [y + size, y, y - size]
    ax.fill(left_x, left_y, transform=ax.transAxes,
            color='white', edgecolor='black', linewidth=0.8, zorder=30)
    ax.fill(right_x, right_y, transform=ax.transAxes,
            color='black', edgecolor='black', linewidth=0.8, zorder=30)
    ax.text(x, y + size + 0.015, 'N', transform=ax.transAxes,
            ha='center', va='bottom', fontsize=10, fontweight='bold', zorder=30)


def add_scale_bar(ax, x, y, length_m, label, crs='EPSG:3857'):
    """Barra de escala em coordenadas de dados (Web Mercator)."""
    ax.plot([x, x + length_m], [y, y], color='black', linewidth=2.5, zorder=30)
    ax.plot([x, x], [y - 300, y + 300], color='black', linewidth=2.5, zorder=30)
    ax.plot([x + length_m, x + length_m], [y - 300, y + 300],
            color='black', linewidth=2.5, zorder=30)
    ax.text(x + length_m / 2, y + 500, label, ha='center', fontsize=9,
            fontweight='bold', zorder=30,
            bbox=dict(facecolor='white', alpha=0.7, edgecolor='none', pad=1))


def format_tick(val, transformer, axis='lon'):
    """Converte Web Mercator → grau (DMS simplificado)."""
    if axis == 'lon':
        lon, _ = transformer.transform(val, 0)
        d = abs(lon)
        return f"{d:.1f}°W"
    else:
        _, lat = transformer.transform(0, val)
        d = abs(lat)
        return f"{d:.1f}°S"


# ── Script principal ──────────────────────────────────────────────────

def main():
    print("▸ Baixando limites geográficos (geobr)...")

    # 1 · Limites geográficos
    br_states = geobr.read_state(year=2020)
    bahia = br_states[br_states['abbrev_state'] == 'BA']

    ba_munis = geobr.read_municipality(code_muni='BA', year=2020)
    jeremoabo = ba_munis[ba_munis['name_muni'] == 'Jeremoabo']

    if jeremoabo.empty:
        # Fallback: buscar por código IBGE
        jeremoabo = ba_munis[ba_munis['code_muni'] == 2922003]

    if jeremoabo.empty:
        print("Erro: município de Jeremoabo não encontrado.")
        return

    # Municípios do Território Semiárido Nordeste II
    territorio_nomes = [
        'Adustina', 'Antas', 'Banzaê', 'Cícero Dantas', 'Cipó',
        'Coronel João Sá', 'Euclides Da Cunha', 'Fátima', 'Heliópolis',
        'Jeremoabo', 'Nova Soure', 'Novo Triunfo', 'Paripiranga',
        'Pedro Alexandre', 'Ribeira Do Amparo', 'Ribeira Do Pombal',
        'Santa Brígida', 'Sítio Do Quinto',
    ]
    # Normalizar nomes para comparação
    norm = lambda s: s.strip().upper()
    territorio = ba_munis[ba_munis['name_muni'].apply(norm).isin([norm(n) for n in territorio_nomes])]

    # Reprojetar para Web Mercator (contextily)
    br_states_wm   = br_states.to_crs(epsg=3857)
    bahia_wm       = bahia.to_crs(epsg=3857)
    ba_munis_wm    = ba_munis.to_crs(epsg=3857)
    jeremoabo_wm   = jeremoabo.to_crs(epsg=3857)
    territorio_wm  = territorio.to_crs(epsg=3857)

    # Comunidades para GeoDataFrame (EPSG:4326 → 3857)
    from shapely.geometry import Point
    com_geom = [Point(lon, lat) for lat, lon in COMUNIDADES.values()]
    gdf_com  = gpd.GeoDataFrame(
        {'nome': list(COMUNIDADES.keys())},
        geometry=com_geom, crs='EPSG:4326',
    ).to_crs(epsg=3857)

    # Sede municipal
    sede_pt = gpd.GeoDataFrame(
        {'nome': ['Jeremoabo (Sede)']},
        geometry=[Point(SEDE_JEREMOABO[1], SEDE_JEREMOABO[0])],
        crs='EPSG:4326',
    ).to_crs(epsg=3857)

    # 2 · Layout da figura
    print("▸ Gerando figura...")
    fig = plt.figure(figsize=(14, 9))
    gs  = GridSpec(1, 2, width_ratios=[1, 3], figure=fig, wspace=0.04)

    # ─── Coluna esquerda: insets ──────────────────────────────────────
    gs_left = gs[0].subgridspec(3, 1, height_ratios=[1.2, 1.2, 0.6], hspace=0.25)

    # (a) Brasil com destaque para Bahia
    ax_br = fig.add_subplot(gs_left[0])
    br_states_wm.plot(ax=ax_br, color='#f0f0f0', edgecolor='gray', linewidth=0.4)
    bahia_wm.plot(ax=ax_br, color='#2c7fb8', edgecolor='black', linewidth=0.8)
    ax_br.set_title('(a) Localização na Bahia', fontsize=10, fontweight='bold', pad=6)
    ax_br.axis('off')

    # (b) Bahia com destaque para Território e Jeremoabo
    ax_ba = fig.add_subplot(gs_left[1])
    ba_munis_wm.plot(ax=ax_ba, color='#f7f7f7', edgecolor='#cccccc', linewidth=0.3)
    territorio_wm.plot(ax=ax_ba, color='#fddbc7', edgecolor='#e08060', linewidth=0.6)
    jeremoabo_wm.plot(ax=ax_ba, color='#d73027', edgecolor='black', linewidth=1.0)
    ax_ba.set_title('(b) Território Semiárido\n     Nordeste II', fontsize=10,
                    fontweight='bold', pad=6)
    ax_ba.axis('off')

    # (c) Legenda
    ax_leg = fig.add_subplot(gs_left[2])
    ax_leg.axis('off')
    legend_handles = [
        Patch(facecolor='#fddbc7', edgecolor='#e08060', linewidth=1,
              label='Território Semiárido NE II'),
        Patch(facecolor='#d73027', edgecolor='black', linewidth=1,
              label='Jeremoabo (BA)'),
        Line2D([0], [0], marker='o', color='w', markerfacecolor='#e31a1c',
               markeredgecolor='white', markersize=10,
               label='Comunidade Quilombola'),
        Line2D([0], [0], marker='s', color='w', markerfacecolor='#FFD700',
               markeredgecolor='black', markersize=9,
               label='Sede Municipal'),
    ]
    ax_leg.legend(handles=legend_handles, loc='center', frameon=True,
                  fancybox=True, shadow=True, fontsize=9,
                  title='LEGENDA', title_fontsize=10)

    # ─── Painel principal: mapa de satélite ───────────────────────────
    ax_main = fig.add_subplot(gs[1])

    # Limites: Jeremoabo com margem
    bounds = jeremoabo_wm.total_bounds
    mx = (bounds[2] - bounds[0]) * 0.08
    my = (bounds[3] - bounds[1]) * 0.08
    ax_main.set_xlim(bounds[0] - mx, bounds[2] + mx)
    ax_main.set_ylim(bounds[1] - my, bounds[3] + my)

    # Basemap satélite
    try:
        ctx.add_basemap(ax_main, source=ctx.providers.Esri.WorldImagery, zoom=11)
    except Exception as e:
        print(f"  Aviso: basemap satélite falhou ({e}), tentando OpenTopoMap...")
        try:
            ctx.add_basemap(ax_main, source=ctx.providers.OpenTopoMap, zoom=11)
        except Exception:
            pass

    # Limite municipal (borda branca grossa + borda fina)
    jeremoabo_wm.plot(ax=ax_main, facecolor='none', edgecolor='white',
                      linewidth=3.0, zorder=5)
    jeremoabo_wm.plot(ax=ax_main, facecolor='none', edgecolor='#FFD700',
                      linewidth=1.5, linestyle='--', zorder=6)

    # Municípios vizinhos do território (bordas semi-transparentes)
    vizinhos = territorio_wm[territorio_wm['name_muni'].apply(norm) != norm('Jeremoabo')]
    vizinhos.plot(ax=ax_main, facecolor='none', edgecolor='white',
                  linewidth=1.0, linestyle=':', alpha=0.6, zorder=4)

    # Plotar comunidades quilombolas
    gdf_com.plot(ax=ax_main, color='#e31a1c', markersize=80,
                 edgecolor='white', linewidth=1.2, zorder=15, marker='o')

    # Sede municipal
    sede_pt.plot(ax=ax_main, color='#FFD700', markersize=100,
                 edgecolor='black', linewidth=1.0, zorder=16, marker='s')

    # Rótulos das comunidades
    text_effect = [pe.withStroke(linewidth=3, foreground='black')]
    for _, row in gdf_com.iterrows():
        x, y = row.geometry.x, row.geometry.y
        ax_main.annotate(
            row['nome'], xy=(x, y), xytext=(8, 5),
            textcoords='offset points', fontsize=7.5, fontweight='bold',
            color='white', zorder=20,
            path_effects=text_effect,
        )

    # Rótulo sede
    sx, sy = sede_pt.geometry.iloc[0].x, sede_pt.geometry.iloc[0].y
    ax_main.annotate(
        'Jeremoabo\n(Sede)', xy=(sx, sy), xytext=(10, -15),
        textcoords='offset points', fontsize=8, fontweight='bold',
        color='#FFD700', zorder=20,
        path_effects=text_effect,
        arrowprops=dict(arrowstyle='->', color='#FFD700', lw=1.2),
    )

    # Elementos cartográficos
    add_north_arrow(ax_main, 0.95, 0.92)

    xlim = ax_main.get_xlim()
    ylim = ax_main.get_ylim()
    add_scale_bar(ax_main, xlim[0] + (xlim[1]-xlim[0])*0.05,
                  ylim[0] + (ylim[1]-ylim[0])*0.04,
                  length_m=10000, label='10 km')

    # Coordenadas em graus
    to_geo = Transformer.from_crs('EPSG:3857', 'EPSG:4326', always_xy=True)
    from matplotlib.ticker import FuncFormatter
    ax_main.xaxis.set_major_formatter(
        FuncFormatter(lambda v, p: format_tick(v, to_geo, 'lon')))
    ax_main.yaxis.set_major_formatter(
        FuncFormatter(lambda v, p: format_tick(v, to_geo, 'lat')))
    ax_main.xaxis.set_major_locator(plt.MaxNLocator(5))
    ax_main.yaxis.set_major_locator(plt.MaxNLocator(5))
    ax_main.tick_params(labelsize=8, colors='white')
    ax_main.grid(True, linestyle='--', alpha=0.2, color='white')
    for spine in ax_main.spines.values():
        spine.set_edgecolor('white')
        spine.set_linewidth(1.5)

    ax_main.set_title(
        '(c) Comunidades Quilombolas em Jeremoabo – BA\n'
        '     Território de Identidade Semiárido Nordeste II',
        fontsize=13, fontweight='bold', pad=12, color='#333333',
    )

    # Créditos
    ax_main.text(
        0.99, 0.01,
        'Imagem: Esri World Imagery | Limites: IBGE (2020)\nDatum: SIRGAS 2000 (WGS 84)',
        transform=ax_main.transAxes, ha='right', va='bottom',
        fontsize=7, color='white', alpha=0.8,
        bbox=dict(facecolor='black', alpha=0.4, edgecolor='none', pad=2),
    )

    # 3 · Salvar
    for out_path in [
        OUTPUT_DIR / 'mapa_territorio_satelite.png',
        FIGURAS_DIR / 'territorio_satelite.png',
    ]:
        plt.savefig(out_path, dpi=300, bbox_inches='tight', facecolor='white')
        print(f"  ✓ Salvo: {out_path}")

    plt.close()
    print("▸ Concluído!")


if __name__ == '__main__':
    main()
