# ÍNDICE DE SCRIPTS - REVISÃO SISTEMÁTICA

## 🎯 Scripts Principais (Ordem de Uso Recomendada)

### 1. **filtrar_referencias_v2.py** ⭐ PRINCIPAL
**Função**: Filtragem inteligente de referências com sistema de pontuação ponderada
**Uso**: `python filtrar_referencias_v2.py`
**Entrada**: Arquivo .bib com referências brutas
**Saída**: Arquivo filtrado + relatório detalhado
**Status**: ✅ Versão final - Recomendada para uso

### 2. **verificar_metodologia_completo.py** ⭐ IMPORTANTE
**Função**: Verificação completa de citações da metodologia
**Uso**: `python verificar_metodologia_completo.py`
**Entrada**: Arquivos .tex da metodologia + references.bib
**Saída**: Relatório de cobertura + referências faltantes
**Status**: ✅ Versão final - Essencial para teses

### 3. **converter_citacoes_metodos.py**
**Função**: Conversão de formato (Autor, ano) para \cite{chave}
**Uso**: `python converter_citacoes_metodos.py`
**Entrada**: Arquivos .tex com citações no formato antigo
**Saída**: Arquivos com citações convertidas
**Status**: ✅ Utilitário especializado

---

## 🔧 Scripts de Suporte

### 4. **filtrar_referencias_v1.py**
**Função**: Primeira versão do filtro (mais simples)
**Status**: 📋 Histórico - Mantido para referência
**Uso**: Apenas para comparação com v2

### 5. **verificar_citacoes_metodos.py**
**Função**: Verificação básica de citações
**Status**: 📋 Histórico - Substituído pelo verificar_metodologia_completo.py

### 6. **analise_citacoes_metodologia.py**
**Função**: Análise detalhada de padrões de citação
**Status**: 📋 Especializado - Para análises específicas

---

## 🚀 Fluxo de Trabalho Recomendado

### Para Nova Revisão Sistemática:
```bash
# 1. Filtrar referências por relevância temática
python filtrar_referencias_v2.py

# 2. Verificar cobertura das citações da metodologia
python verificar_metodologia_completo.py

# 3. (Se necessário) Converter formato de citações
python converter_citacoes_metodos.py
```

### Para Manutenção de Bibliografia:
```bash
# Verificação periódica de citações
python verificar_metodologia_completo.py

# Análise especializada (opcional)
python analise_citacoes_metodologia.py
```

---

## 📊 Comparação de Versões

| Script | Versão | Funcionalidades | Recomendação |
|--------|--------|----------------|--------------|
| filtrar_referencias_v2.py | 2.0 | Sistema completo de pontuação + relatórios | ⭐ USE ESTE |
| filtrar_referencias_v1.py | 1.0 | Filtragem básica por palavras-chave | 📋 Histórico |
| verificar_metodologia_completo.py | Final | Verificação completa + busca em backups | ⭐ USE ESTE |
| verificar_citacoes_metodos.py | Básica | Verificação simples | 📋 Histórico |

---

## 🎓 Parâmetros Configuráveis

### filtrar_referencias_v2.py:
- **Pontuação mínima**: Linha 15 (padrão: 5.0)
- **Termos prioritários**: Linha 25-35
- **Termos de exclusão**: Linha 45-55
- **Arquivo de entrada**: Linha 10

### verificar_metodologia_completo.py:
- **Arquivos de metodologia**: Linha 20-25
- **Arquivos de backup**: Linha 35-40
- **Critérios de busca**: Linha 50-60

---

## 📝 Logs e Debugging

### Arquivos de Log Gerados:
- `relatorio_filtragem_referencias_v2.txt` - Resultado da filtragem
- `relatorio_metodologia_completo.txt` - Análise de metodologia
- `referencias_filtradas_tema_agroecologia_v2.bib` - Referências filtradas
- `referencias_metodologia_encontradas.bib` - Referências recuperadas

### Em Caso de Erro:
1. Verifique se os arquivos de entrada existem
2. Confirme a codificação UTF-8 dos arquivos .bib
3. Verifique as permissões de escrita na pasta
4. Consulte os comentários nos scripts para detalhes

---

## 🔄 Atualizações e Manutenção

### Quando Atualizar:
- **Novos domínios temáticos**: Adicionar termos no filtrar_referencias_v2.py
- **Novos arquivos de metodologia**: Atualizar lista no verificar_metodologia_completo.py
- **Mudança de critérios**: Ajustar pontuações e pesos

### Backup Recomendado:
- Manter cópias dos scripts originais antes de modificações
- Versionar arquivos .bib importantes
- Salvar relatórios de execução para histórico

---

**Última atualização**: Outubro 2025  
**Versão do sistema**: 2.0  
**Compatibilidade**: Python 3.6+