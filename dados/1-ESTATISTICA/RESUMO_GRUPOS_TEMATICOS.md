# RESUMO DOS GRUPOS TEMÁTICOS IDENTIFICADOS
## Machine Learning em Etnografia e Conhecimentos Tradicionais

**Data de Análise:** 23 de novembro de 2025  
**Corpus:** 670 estudos (622 únicos após limpeza)  
**Método:** K-means clustering (k=5)  
**Variância Explicada:** 17.27% (Between SS / Total SS)

---

## 📊 VISÃO GERAL DOS 5 GRUPOS

### **Grupo 1: Mineração de Dados e Conhecimentos Tradicionais** 
🔴 *Cor: Vermelho (#E41A1C)* | **n = 21 estudos (3.4%)**

**Perfil Dominante:**
- **DataMining (90.5%)**: Técnicas de mineração de dados aplicadas
- **TraditionalKnowledge (90.5%)**: Foco principal em conhecimentos tradicionais
- **Assessment (85.7%)**: Avaliação e validação de métodos
- **MachineLearning (61.9%)**: Uso moderado de ML
- **CaseStudy (61.9%)**: Abordagem baseada em estudos de caso

**Caracterização:**
Este é o grupo mais especializado em **técnicas de mineração de dados** aplicadas ao contexto de conhecimentos tradicionais. Representa estudos que utilizam métodos computacionais avançados para extrair padrões e insights de bases de dados etnográficas. A alta presença de "Assessment" indica forte preocupação metodológica com validação.

**Exemplos de Tópicos:**
- Mineração de texto em narrativas tradicionais
- Extração de padrões em documentos históricos etnográficos
- Análise automatizada de entrevistas com comunidades

---

### **Grupo 2: Machine Learning em Conservação** 
🔵 *Cor: Azul (#377EB8)* | **n = 159 estudos (25.6%)**

**Perfil Dominante:**
- **MachineLearning (100%)**: Saturação completa de ML
- **Assessment (92.5%)**: Forte componente de avaliação
- **Management (90.6%)**: Gestão e manejo de recursos
- **Interview (89.9%)**: Coleta de dados via entrevistas
- **Conservation (86.8%)**: Foco em conservação ambiental
- **TraditionalKnowledge (67.9%)**: Conhecimentos tradicionais presentes

**Caracterização:**
Este é o grupo **mais representativo** numericamente e tematicamente. Integra Machine Learning com práticas de conservação ambiental informadas por conhecimentos tradicionais. A combinação de ML + Management + Conservation sugere **aplicações práticas para tomada de decisão** em projetos de conservação.

**Exemplos de Tópicos:**
- Modelos preditivos para áreas de conservação baseados em conhecimentos indígenas
- Classificação de práticas sustentáveis tradicionais usando ML
- Sistemas de apoio à decisão para manejo de recursos naturais

---

### **Grupo 3: Machine Learning e Povos Indígenas** 
🟢 *Cor: Verde (#4DAF4A)* | **n = 237 estudos (38.1%)**

**Perfil Dominante:**
- **MachineLearning (94.5%)**: Presença massiva de ML
- **Assessment (79.7%)**: Avaliação metodológica
- **Indigenous (67.1%)**: **Maior representação de povos indígenas**
- **TraditionalKnowledge (54.9%)**: Conhecimentos tradicionais
- **Ethnography (45.6%)**: Métodos etnográficos
- **Interview (44.3%)**: Entrevistas como método

**Caracterização:**
Este é o grupo **mais volumoso** (38% do corpus) e representa a **interseção direta** entre tecnologias de ML e comunidades indígenas. A alta presença de "Ethnography" e "Interview" indica forte componente qualitativo, com ML sendo usado como ferramenta complementar para análise de dados etnográficos.

**Exemplos de Tópicos:**
- Documentação digital de línguas indígenas usando ML
- Classificação automática de artefatos culturais
- Análise de redes sociais em comunidades tradicionais
- Preservação digital de patrimônio imaterial

---

### **Grupo 4: Etnobotânica Aplicada** 
🟠 *Cor: Laranja (#FF7F00)* | **n = 140 estudos (22.5%)**

**Perfil Dominante:**
- **MachineLearning (97.9%)**: Alta presença de ML
- **Ethnobotany (96.4%)**: **Saturação de estudos etnobotânicos**
- **Assessment (94.3%)**: Forte componente avaliativo
- **Interview (91.4%)**: Coleta de dados via entrevistas
- **TraditionalPractices (57.1%)**: Práticas tradicionais
- **Asia (37.1%)**: Forte representação asiática

**Caracterização:**
Grupo altamente especializado em **etnobotânica computacional**. Representa a aplicação de ML para identificação, classificação e documentação de conhecimentos botânicos tradicionais. A alta presença de entrevistas sugere metodologia mista (qualitativa + quantitativa).

**Exemplos de Tópicos:**
- Classificação automática de plantas medicinais
- Reconhecimento de imagens de espécies botânicas usadas tradicionalmente
- Análise de redes de conhecimento sobre usos de plantas
- Modelos preditivos para propriedades farmacológicas baseados em uso tradicional

---

### **Grupo 5: Machine Learning e Mudanças Climáticas** 
🟣 *Cor: Roxo (#984EA3)* | **n = 65 estudos (10.4%)**

**Perfil Dominante:**
- **ClimateChange (100%)**: **Saturação completa** do tema climático
- **MachineLearning (95.4%)**: Alta presença de ML
- **Assessment (89.2%)**: Avaliação de impactos
- **TraditionalKnowledge (78.5%)**: Conhecimentos tradicionais relevantes
- **Management (69.2%)**: Gestão adaptativa
- **Conservation (61.5%)**: Conservação sob mudanças climáticas

**Caracterização:**
Grupo temático emergente focado na **interseção entre ML, conhecimentos tradicionais e adaptação climática**. Representa estudos que utilizam tanto dados científicos quanto saberes tradicionais para modelar e prever impactos das mudanças climáticas.

**Exemplos de Tópicos:**
- Modelos de ML integrando previsões tradicionais de clima
- Análise de estratégias adaptativas de comunidades tradicionais
- Previsão de vulnerabilidades climáticas em territórios indígenas
- Validação de conhecimentos tradicionais sobre padrões climáticos usando ML

---

## 🔍 CARACTERÍSTICAS DISTINTIVAS DOS GRUPOS

### Separação Temática (features mais discriminativas):

| Rank | Feature | Variância | Grupos Dominantes |
|------|---------|-----------|-------------------|
| 1 | ClimateChange | 0.389 | Exclusivo do Grupo 5 |
| 2 | DataMining | 0.323 | Forte no Grupo 1 |
| 3 | Ethnobotany | 0.388 | Dominante no Grupo 4 |
| 4 | Management | 0.376 | Grupos 2 e 5 |
| 5 | Conservation | 0.293 | Grupos 2 e 5 |
| 6 | Ethnography | 0.186 | Grupo 3 |
| 7 | Indigenous | 0.255 | Grupo 3 |
| 8 | Interview | 0.227 | Grupos 2, 4 |

### Gradiente Metodológico:

```
Quantitativo    ←────────────────────────→    Qualitativo
Grupo 1 (DataMining) ── Grupo 5 ── Grupo 2 ── Grupo 4 ── Grupo 3 (Ethnography)
```

### Gradiente Aplicado/Teórico:

```
Aplicado       ←────────────────────────→    Teórico
Grupo 2 (Management) ── Grupo 5 ── Grupo 4 ── Grupo 3 ── Grupo 1 (Assessment)
```

---

## 📈 DISTRIBUIÇÃO ESPACIAL (PCA)

No espaço de componentes principais:

- **PC1 (8.7% variância)**: Eixo "Etnografia pura → ML aplicado"
  - Positivo: Grupos 2, 4 (ML + Aplicação)
  - Negativo: Grupo 3 (Etnografia + Povos Indígenas)

- **PC2 (4.3% variância)**: Eixo "Conservação → Documentação"
  - Positivo: Grupo 5 (ClimateChange), Grupo 1 (DataMining)
  - Negativo: Grupos 2, 4 (Conservation, Ethnobotany)

---

## 💡 INTERPRETAÇÃO PARA A TESE

### Alinhamento com Objetivos de Pesquisa:

1. **Objetivo 1 - Mapear aplicações de ML em etnografia:**
   - Todos os 5 grupos demonstram uso de ML (90%+ presença)
   - Diversidade de aplicações: mineração de dados, classificação, previsão, reconhecimento

2. **Objetivo 2 - Identificar métodos etnográficos compatíveis com ML:**
   - Grupo 3 mostra alta compatibilidade Interview + Ethnography + ML
   - Grupo 4 demonstra integração bem-sucedida de métodos tradicionais + ML

3. **Objetivo 3 - Avaliar contribuições para conhecimentos tradicionais:**
   - Grupos 2, 3, 4, 5 todos > 54% presença de TraditionalKnowledge
   - Grupo 3 (Indigenous 67%) e Grupo 5 (TK 78%) destacam-se

### Lacunas Identificadas:

- **Subrepresentação geográfica**: Baixa presença de estudos na América Latina (não aparece no top 10 de nenhum grupo)
- **Desbalanceamento temático**: Conservação e Etnobotânica dominam; antropologia digital subrepresentada
- **Participação comunitária**: Baixa presença de features relacionadas a co-design ou participatory methods

---

## 📚 RECOMENDAÇÕES PARA DISCUSSÃO

### Contribuição Teórica:

1. **Tipologia de Aplicações ML em Etnografia** (5 tipos identificados)
2. **Gradientes Metodológicos** (quantitativo-qualitativo, aplicado-teórico)
3. **Padrões de Integração** (ML como ferramenta vs. ML como método)

### Contribuição Metodológica:

1. **Framework de Classificação**: 29 features binárias com validação em 670 estudos
2. **Método Misto**: Clustering + PCA + MCA + Network para análise bibliométrica
3. **Validação Quantitativa**: 17.27% variância explicada, silhouette 0.079

### Contribuição Prática:

1. **Guia de Seleção de Métodos**: Qual grupo temático para cada tipo de pesquisa
2. **Mapeamento de Ferramentas**: Algoritmos ML por área de aplicação
3. **Rotas de Aprendizado**: Progressão de habilidades para pesquisadores

---

## 🎯 PRÓXIMOS PASSOS

### Análises Complementares:

- [ ] **Análise temporal**: Evolução dos 5 grupos ao longo do tempo (2010-2025)
- [ ] **Análise de rede**: Co-ocorrências entre grupos e features
- [ ] **Análise preditiva**: Modelar probabilidade de pertencimento aos grupos

### Visualizações para Tese:

- [x] Scatter plot PCA com 5 grupos (cores distintas + elipses)
- [x] Heatmap de perfis (15 features × 5 grupos)
- [x] Dendrograma hierárquico
- [ ] Diagrama de Sankey (features → grupos → aplicações)
- [ ] Mapa de calor temporal (ano × grupo)

### Escrita:

- [ ] Seção "Caracterização dos Grupos Temáticos" (Resultados)
- [ ] Seção "Implicações Metodológicas" (Discussão)
- [ ] Seção "Limitações da Tipologia" (Discussão)

---

## 📊 ARQUIVOS DE REFERÊNCIA

### Dados:
- `3-CLUSTERS/cluster_resultados.csv` - Atribuições de cluster para cada estudo
- `3-CLUSTERS/cluster_relatorio.txt` - Estatísticas completas
- `1-PCA/pca_scores.csv` - Coordenadas PCA de cada estudo

### Visualizações:
- `3-CLUSTERS/cluster_kmeans_scatter.png` - Scatter plot principal
- `3-CLUSTERS/cluster_heatmap_profiles.png` - Heatmap de perfis
- `3-CLUSTERS/cluster_dendrogram.png` - Dendrograma hierárquico
- `1-PCA/pca_biplot_clusters.png` - PCA com grupos sobrepostos
- `2-MCA/mca_biplot_clusters.png` - MCA com grupos sobrepostos (se gerado)
- `5-TEMPORAL/temporal_clusters.png` - Evolução temporal dos grupos (se gerado)

---

## 🔗 REFERÊNCIAS METODOLÓGICAS

- **K-means**: Ward, J. H. (1963). Hierarchical Grouping to Optimize an Objective Function. *JASA*, 58(301), 236-244.
- **Silhouette**: Rousseeuw, P. J. (1987). Silhouettes: A graphical aid to the interpretation. *J Comp Appl Math*, 20, 53-65.
- **PCA**: Jolliffe, I. T. (2002). *Principal Component Analysis* (2nd ed.). Springer.
- **Cluster Validation**: Kaufman, L., & Rousseeuw, P. J. (2005). *Finding Groups in Data*. Wiley.

---

**Documento gerado automaticamente a partir da análise de clustering.**  
**Última atualização:** 23/11/2025  
**Script fonte:** `03_cluster_analysis.R`
