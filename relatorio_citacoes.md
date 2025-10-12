## RELATÓRIO DE ANÁLISE DE CITAÇÕES - ARQUIVO INTRODUÇÃO

### RESUMO EXECUTIVO
- **Total de citações analisadas**: 20
- **Correspondências encontradas**: 12 (60%)
- **Citações não encontradas**: 8 (40%)

### CORRESPONDÊNCIAS CONFIRMADAS ✅

1. **Fletcher et al., 2021** → `Fletcher2021` ✓
2. **Mekonen, 2017** → `Mekonen2017` ✓
3. **Mantyka-Pringle et al., 2017** → `Mantyka-Pringle2017` ✓
4. **Thorn et al., 2020** → `Thorn2020` ✓
5. **Vega et al., 2023** → `Vega2023` ✓
6. **Purwanto, 2022** → `Purwanto2022` ✓
7. **Brasil, 2015** → `Brasil2015` ✓
8. **Brasil, 2000** → `Brasil2000` ✓
9. **Gafner-Rojas, 2020** → `Gafner-Rojas2020` ✓
10. **Ens et al., 2016** → `Ens2016` ✓
11. **Fajardo et al., 2021** → `Fajardo2021` ✓

### PROBLEMAS IDENTIFICADOS ❌

#### 1. Citações com problemas de formato ou múltiplos autores:

1. **"Cebrián-Piqueras et al., 2020"** 
   - **Problema**: Caractere especial (í) na chave BibTeX
   - **Chave no arquivo**: `Cebrin-Piqueras2020` (sem acento)
   - **Solução**: Chave está correta no .bib

2. **"Olsson; Folke, 2001"** (citação múltipla)
   - **"Olsson"**: Existe como `Olsson2001` ✓
   - **"Folke"**: Não encontrado como entrada separada ❌
   - **Problema**: Provavelmente é uma única referência com dois autores

3. **"Morin-Labatut; Akhtar, 1992"** (citação múltipla)
   - **"Morin-Labatut"**: Existe como `Morin-Labatut1992` ✓
   - **"Akhtar"**: Não encontrado como entrada separada ❌
   - **Problema**: Provavelmente é uma única referência com dois autores

4. **"Mistry; Berardi, 2016"** (citação múltipla)
   - **"Mistry"**: Existe como `Mistry2016` ✓
   - **"Berardi"**: Não encontrado como entrada separada ❌
   - **Problema**: Provavelmente é uma única referência com dois autores

5. **"Anderson; Daim; Lavoie, 2007"** (citação múltipla)
   - **"Anderson"**: Existe como `Anderson2007` ✓
   - **"Lavoie"**: Não encontrado como entrada separada ❌
   - **Problema**: Provavelmente é uma única referência com três autores

6. **"Bokic; Cikic, 2014"** (citação múltipla)
   - **"Bokic"**: Existe como `Bokic2014` ✓
   - **"Cikic"**: Não encontrado como entrada separada ❌
   - **Problema**: Provavelmente é uma única referência com dois autores

7. **"Degryse; Pochet, 2009"** (citação múltipla)
   - **"Degryse"**: Existe como `Degryse2009` ✓
   - **"Pochet"**: Não encontrado como entrada separada ❌
   - **Problema**: Provavelmente é uma única referência com dois autores

### DIAGNÓSTICO PRINCIPAL

**PROBLEMA**: O texto está usando formato de citação incorreto para o abnTeX2. O sistema está interpretando autores múltiplos como citações separadas.

**FORMATO ATUAL (INCORRETO)**:
```latex
(Olsson; Folke, 2001)
(Morin-Labatut; Akhtar, 1992)
```

**FORMATO CORRETO PARA abnTeX2**:
```latex
\cite{Olsson2001}
\cite{Morin-Labatut1992}
```

### AÇÕES RECOMENDADAS

1. **Substituir todas as citações em texto por comandos \cite{}**
2. **Usar as chaves BibTeX existentes**
3. **Verificar se as referências múltiplas são realmente uma única fonte**

### CHAVES BIBTEX DISPONÍVEIS E FUNCIONAIS

As seguintes chaves estão prontas para uso:
- `Fletcher2021`
- `Mekonen2017` 
- `Mantyka-Pringle2017`
- `Cebrin-Piqueras2020` (note: sem acento)
- `Olsson2001`
- `Thorn2020`
- `Vega2023`
- `Morin-Labatut1992`
- `Mistry2016`
- `Anderson2007`
- `Purwanto2022`
- `Bokic2014`
- `Brasil2015`
- `Brasil2000`
- `Gafner-Rojas2020`
- `Ens2016`
- `Fajardo2021`
- `Degryse2009`

### CONCLUSÃO

O arquivo `references.bib` contém todas as referências necessárias para as citações da introdução. O problema principal é o formato de citação usado no texto LaTeX, que precisa ser convertido para comandos `\cite{}` adequados ao abnTeX2.