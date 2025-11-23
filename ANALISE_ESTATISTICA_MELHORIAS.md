# 📊 Análise Estatística e Sugestões de Melhorias
## Arquivos: Met_gestao_pi.tex e Met_validacao.tex

**Data da Análise:** 25/10/2025  
**Objetivo:** Identificar oportunidades de aprimoramento estatístico nas seções de Gestão de PI e Validação

---

## 🎯 RESUMO EXECUTIVO

### Pontos Fortes Identificados:
✅ Estrutura metodológica robusta com triangulação de métodos  
✅ Abordagem multinível de validação bem delineada  
✅ Uso de métricas de redes sociais (centralidade, betweenness, closeness)  
✅ Referência a testes estatísticos (teste T, Mann-Whitney)  
✅ Menção a diferenças em diferenças (difference-in-differences)

### Gaps Estatísticos Críticos Identificados:
❌ **Falta de especificação de tamanho amostral e poder estatístico**  
❌ **Ausência de correção para testes múltiplos**  
❌ **Falta de análise de confiabilidade inter-avaliadores**  
❌ **Ausência de modelagem de dados hierárquicos/aninhados**  
❌ **Falta de análise de mediação e moderação**  
❌ **Ausência de testes de robustez e análise de sensibilidade estatística**

---

## 📋 ANÁLISE DETALHADA POR SEÇÃO

---

## 1️⃣ **Met_gestao_pi.tex - Análise de Redes Sociais**

### 🔍 Situação Atual:
```tex
Para cada rede, serão calculadas métricas padrão de análise de redes: 
centralidade de grau, centralidade de betweenness, centralidade de closeness, 
e coesão de grupos (clusters).
```

### ⚠️ Problemas Estatísticos:

1. **Falta de testes de significância para métricas de rede**
   - Não há menção a testes de permutação para avaliar se as métricas observadas diferem do acaso
   - Ausência de intervalos de confiança para as métricas de centralidade

2. **Ausência de análise de comunidades (community detection)**
   - Não especifica algoritmos: Louvain, Girvan-Newman, Walktrap?
   - Falta validação da qualidade da detecção (modularidade)

3. **Falta de análise temporal/longitudinal**
   - As redes mudam ao longo do tempo, mas não há modelo de evolução

### ✅ SUGESTÕES DE MELHORIA:

#### **Adicionar após as métricas de rede:**

```latex
Para avaliar a significância estatística das métricas de centralidade, serão realizados 
testes de permutação (1000 iterações) comparando as métricas observadas com distribuições 
nulas geradas aleatoriamente, estabelecendo valores-p para cada métrica. Intervalos de 
confiança de 95% serão calculados via bootstrap para as métricas de centralidade.

A detecção de comunidades será realizada utilizando o algoritmo de Louvain, com validação 
da qualidade da partição através do cálculo de modularidade (Q). Valores de Q > 0.3 serão 
considerados indicativos de estrutura comunitária significativa. A estabilidade das 
comunidades detectadas será testada através de análise de sensibilidade, variando 
parâmetros de resolução e comparando partições obtidas.

Para análise longitudinal, serão aplicados modelos de redes temporais (Temporal Exponential 
Random Graph Models - TERGM) para identificar mecanismos de formação e dissolução de laços 
ao longo do tempo, controlando por efeitos de reciprocidade, transitividade e homofilia.
```

---

## 2️⃣ **Met_gestao_pi.tex - Indicadores de Ecossistema**

### 🔍 Situação Atual:
```tex
Serão monitorados: taxa de participação, qualidade das decisões, 
velocidade de resolução de conflitos, proporção de conhecimentos 
que progridem através de estágios...
```

### ⚠️ Problemas Estatísticos:

1. **Falta de linha de base (baseline) estatisticamente estabelecida**
2. **Ausência de grupos de comparação ou controle**
3. **Não especifica como lidar com dados faltantes (missing data)**
4. **Falta de ajuste para fatores de confusão**

### ✅ SUGESTÕES DE MELHORIA:

```latex
\subsubsection{Desenho Estatístico para Avaliação de Indicadores}

Será estabelecida linha de base (baseline) mediante coleta de dados pré-implementação 
em todas as comunidades participantes e em 2-3 comunidades controle pareadas por 
características socioeconômicas (tamanho, acesso a serviços, perfil produtivo). O 
pareamento será realizado via propensity score matching para minimizar viés de seleção.

Para análise de mudanças ao longo do tempo, serão aplicados modelos de efeitos mistos 
(mixed-effects models) que consideram a estrutura hierárquica dos dados (medidas 
repetidas aninhadas em indivíduos, indivíduos aninhados em comunidades). A especificação 
incluirá:
- Efeitos fixos: tempo, grupo (tratamento/controle), interação tempo×grupo
- Efeitos aleatórios: interceptos aleatórios por comunidade e por indivíduo

Dados faltantes serão tratados via multiple imputation (m=20 imputações) utilizando 
algoritmo MICE (Multivariate Imputation by Chained Equations), com variáveis preditoras 
incluindo características baseline e padrões de missing. Análises de sensibilidade 
compararão resultados com complete case analysis e pattern-mixture models.

Tamanho amostral: considerando poder estatístico de 80%, alfa=0.05, e tamanho de 
efeito esperado de d=0.5 (médio), serão necessários aproximadamente 64 indivíduos 
por grupo (total n≈128) para detectar diferenças significativas em indicadores contínuos.
```

---

## 3️⃣ **Met_validacao.tex - Validação Técnico-Científica**

### 🔍 Situação Atual:
```tex
Para os componentes computacionais e de machine learning, serão realizados 
testes de desempenho rigorosos contemplando múltiplas dimensões: acurácia 
preditiva, estabilidade, escalabilidade, interpretabilidade...
```

### ⚠️ Problemas Estatísticos:

1. **Falta de especificação de métricas de desempenho além de acurácia**
2. **Ausência de validação cruzada estratificada**
3. **Não menciona correção para classes desbalanceadas**
4. **Falta de análise de curva ROC e AUC**

### ✅ SUGESTÕES DE MELHORIA:

```latex
\paragraph{Validação Estatística de Modelos de Machine Learning}

Além da acurácia geral, serão calculadas métricas complementares apropriadas para 
avaliação balanceada:
- \textbf{Precisão} (precision): proporção de predições positivas corretas
- \textbf{Revocação} (recall/sensitivity): proporção de casos positivos identificados
- \textbf{F1-score}: média harmônica entre precisão e revocação
- \textbf{Especificidade}: proporção de casos negativos corretamente identificados
- \textbf{Balanced accuracy}: média entre sensibilidade e especificidade

Para problemas de classificação binária, será construída curva ROC (Receiver Operating 
Characteristic) e calculada a área sob a curva (AUC-ROC). Valores de AUC > 0.8 serão 
considerados indicativos de bom desempenho discriminativo. Intervalos de confiança 
de 95% para AUC serão calculados via método DeLong.

A validação cruzada será estratificada (stratified k-fold, k=10) para preservar a 
distribuição de classes em cada fold. Em casos de classes desbalanceadas, serão 
aplicadas técnicas de:
- \textbf{Oversampling} da classe minoritária via SMOTE (Synthetic Minority Over-sampling)
- \textbf{Undersampling} da classe majoritária
- \textbf{Pesos de classe} ajustados proporcionalmente ao inverso da frequência

Testes de hipóteses compararão o desempenho do modelo proposto com baselines mediante 
teste de McNemar (para comparação de acurácias) ou teste de DeLong (para comparação 
de AUCs), com correção de Bonferroni para múltiplas comparações (α ajustado = 0.05/k, 
onde k = número de comparações).
```

---

## 4️⃣ **Met_validacao.tex - Análise de Correlação e Causalidade**

### 🔍 Situação Atual:
```tex
Um indicador particularmente relevante é a relação entre valoração técnica 
e percepção comunitária de importância. Espera-se alguma correlação...
```

### ⚠️ Problemas Estatísticos:

1. **Não especifica qual tipo de correlação (Pearson, Spearman, Kendall)**
2. **Ausência de testes de mediação/moderação**
3. **Falta de análise de equações estruturais (SEM)**
4. **Não menciona como controlar por variáveis confundidoras**

### ✅ SUGESTÕES DE MELHORIA:

```latex
\paragraph{Análise de Associações e Modelagem Causal}

A relação entre valoração técnica (derivada algoritmicamente) e percepção comunitária 
será investigada mediante múltiplas abordagens complementares:

\textbf{Análise Correlacional:}
- Correlação de Pearson para variáveis contínuas com distribuição normal
- Correlação de Spearman para variáveis ordinais ou não-normais
- Correção para atenuação devido a erro de medição
- Intervalos de confiança de 95% via transformação de Fisher z
- Testes de significância com correção FDR (False Discovery Rate) para múltiplas 
  comparações

\textbf{Modelagem de Regressão Múltipla:}
Para controlar fatores de confusão, serão estimados modelos de regressão múltipla:

Modelo 1 (bivariado):
$$\text{Percepção} = \beta_0 + \beta_1 \cdot \text{Valoração Técnica} + \epsilon$$

Modelo 2 (ajustado):
$$\text{Percepção} = \beta_0 + \beta_1 \cdot \text{Valoração Técnica} + \beta_2 \cdot 
\text{Escolaridade} + \beta_3 \cdot \text{Idade} + \beta_4 \cdot \text{Engajamento} 
+ \epsilon$$

Diagnósticos incluirão: teste de multicolinearidade (VIF < 5), análise de resíduos, 
teste de heterocedasticidade (Breusch-Pagan), e identificação de outliers influentes 
(distância de Cook).

\textbf{Análise de Mediação e Moderação:}
Para testar se a relação entre valoração técnica e impacto territorial é mediada por 
percepção comunitária, será aplicado o método de Baron e Kenny com teste de Sobel 
para significância do efeito indireto. Adicionalmente, serão utilizados modelos de 
mediação via bootstrap (5000 iterações) para estimar intervalos de confiança do 
efeito indireto.

Análise de moderação testará se características comunitárias (ex: nível de organização 
social) moderam a relação entre valoração e adoção:
$$Y = \beta_0 + \beta_1 X + \beta_2 M + \beta_3 (X \times M) + \epsilon$$

onde o termo de interação $\beta_3$ indica efeito de moderação.

\textbf{Inferência Causal via Difference-in-Differences:}
Para comunidades implementando o modelo em tempos diferentes (staggered adoption), 
será estimado modelo DiD:
$$Y_{it} = \alpha + \beta \cdot \text{Post}_t + \gamma \cdot \text{Treated}_i + 
\delta (\text{Post}_t \times \text{Treated}_i) + \mathbf{X}_{it}'\boldsymbol{\theta} 
+ \epsilon_{it}$$

onde $\delta$ captura o efeito causal do tratamento. Pressupostos de tendências 
paralelas serão testados graficamente e via teste de Wald. Erros-padrão serão 
clusterizados no nível de comunidade.
```

---

## 5️⃣ **Met_validacao.tex - Análise Qualitativa**

### 🔍 Situação Atual:
```tex
Análise qualitativa incluirá codificação temática de entrevistas e grupos 
focais para identificar padrões em percepções e experiências...
```

### ⚠️ Problemas Estatísticos:

1. **Falta de medidas de concordância inter-codificadores (inter-rater reliability)**
2. **Ausência de critérios de saturação teórica**
3. **Não especifica software de análise qualitativa (ATLAS.ti, NVivo, MAXQDA)**
4. **Falta de validação comunicativa/member checking**

### ✅ SUGESTÕES DE MELHORIA:

```latex
\paragraph{Rigor e Confiabilidade em Análise Qualitativa}

A codificação temática será realizada por dois codificadores independentes treinados, 
utilizando software NVivo (versão 14). A confiabilidade inter-codificadores será 
avaliada mediante:
- \textbf{Coeficiente Kappa de Cohen} para concordância em códigos binários
- \textbf{Krippendorff's Alpha} para códigos ordinais ou nominais múltiplos
- Valores κ > 0.80 ou α > 0.80 serão considerados indicativos de alta confiabilidade

Discordâncias serão resolvidas mediante discussão entre codificadores e consulta a 
terceiro pesquisador quando necessário. O processo iterativo incluirá:
1. Codificação independente de 20% das entrevistas
2. Cálculo de concordância
3. Discussão e refinamento do livro de códigos
4. Codificação do restante dos dados
5. Verificação final de consistência

\textbf{Saturação Teórica:}
A saturação será monitorada continuamente durante a coleta. Considera-se atingida 
quando três entrevistas/grupos focais consecutivos não revelarem novos temas ou 
códigos emergentes. Documentação incluirá:
- Matriz de temas × entrevistas mostrando ponto de saturação
- Memorandos analíticos justificando decisão de interromper coleta

\textbf{Validação Comunicativa (Member Checking):}
Resultados preliminares da análise qualitativa serão apresentados a subamostras de 
participantes (n≈10) em sessões de devolutiva, solicitando feedback sobre:
- Acurácia das interpretações
- Representatividade das citações selecionadas
- Identificação de nuances não capturadas

Discrepâncias identificadas serão incorporadas mediante revisão analítica.

\textbf{Triangulação Metodológica:}
Convergência entre dados qualitativos e quantitativos será avaliada mediante matriz 
de triangulação comparando padrões, frequências e intensidades. Discrepâncias serão 
investigadas em profundidade para identificar se refletem limitações metodológicas 
ou complexidade do fenômeno.
```

---

## 6️⃣ **Met_validacao.tex - Testes de Hipóteses**

### 🔍 Situação Atual:
```tex
testes de significância para detectar se variações pré-pós são genuínas 
(testes T, Mann-Whitney conforme distribuição)...
```

### ⚠️ Problemas Estatísticos:

1. **Falta de testes de pressupostos (normalidade, homocedasticidade)**
2. **Ausência de correção para comparações múltiplas**
3. **Não especifica testes pareados vs. não-pareados**
4. **Falta de cálculo de tamanho de efeito (effect size)**

### ✅ SUGESTÕES DE MELHORIA:

```latex
\paragraph{Especificação Rigorosa de Testes de Hipóteses}

\textbf{Verificação de Pressupostos:}
Antes de aplicar testes paramétricos, serão verificados:
- \textbf{Normalidade}: teste de Shapiro-Wilk (n<50) ou Kolmogorov-Smirnov (n≥50), 
  complementados por inspeção visual de Q-Q plots
- \textbf{Homocedasticidade}: teste de Levene para igualdade de variâncias
- \textbf{Independência}: avaliação do desenho do estudo e gráficos de resíduos

\textbf{Seleção de Testes Apropriados:}

Para comparações pré-pós em \textbf{mesmos indivíduos} (medidas repetidas):
- Se normalidade satisfeita: \textbf{teste t pareado}
- Se normalidade violada: \textbf{teste de Wilcoxon signed-rank}

Para comparações entre \textbf{grupos independentes}:
- Se normalidade e homocedasticidade satisfeitas: \textbf{teste t independente}
- Se normalidade satisfeita mas variâncias desiguais: \textbf{teste t de Welch}
- Se normalidade violada: \textbf{teste de Mann-Whitney U}

Para comparações de \textbf{mais de dois grupos}:
- Paramétrico: \textbf{ANOVA} one-way com testes post-hoc (Tukey HSD, Bonferroni)
- Não-paramétrico: \textbf{teste de Kruskal-Wallis} com testes post-hoc (Dunn)

\textbf{Correção para Múltiplas Comparações:}
Quando múltiplos testes forem realizados, será aplicada correção mediante:
- \textbf{Bonferroni}: α ajustado = α/k (conservador)
- \textbf{Holm-Bonferroni}: método sequencial menos conservador
- \textbf{False Discovery Rate (FDR)}: método de Benjamini-Hochberg para 
  controlar proporção de falsos positivos

\textbf{Tamanho de Efeito:}
Para cada teste significativo, será reportado tamanho de efeito:
- Para teste t: \textbf{d de Cohen} = $\frac{\bar{X}_1 - \bar{X}_2}{s_{pooled}}$
  - Pequeno: d ≈ 0.2
  - Médio: d ≈ 0.5
  - Grande: d ≈ 0.8
- Para Mann-Whitney: \textbf{r} = $\frac{Z}{\sqrt{N}}$
- Para ANOVA: \textbf{η² parcial} (eta-squared)
- Para qui-quadrado: \textbf{V de Cramér} ou \textbf{φ} (phi)

\textbf{Intervalos de Confiança:}
Além de valores-p, serão reportados intervalos de confiança de 95% para todas as 
estimativas de diferenças, ratios e tamanhos de efeito, permitindo avaliação de 
magnitude e precisão.

\textbf{Poder Estatístico Post-hoc:}
Para testes não-significativos, será calculado poder estatístico observado para 
avaliar se a ausência de significância reflete genuína ausência de efeito ou 
insuficiência amostral.
```

---

## 7️⃣ **NOVAS SEÇÕES RECOMENDADAS**

### 📌 **Seção Adicional 1: Análise de Dados Hierárquicos**

```latex
\subsubsection{Modelagem Estatística de Dados Hierárquicos}

Reconhecendo a estrutura aninhada dos dados (medidas repetidas dentro de indivíduos, 
indivíduos dentro de comunidades, comunidades dentro de territórios), serão utilizados 
modelos multinível (hierarchical linear models ou mixed-effects models) para capturar 
adequadamente a variância em diferentes níveis.

\textbf{Modelo de Três Níveis - Exemplo:}

Nível 1 (tempo): $Y_{tij} = \pi_{0ij} + \pi_{1ij} \cdot \text{Tempo}_{tij} + e_{tij}$

Nível 2 (indivíduo): 
$$\pi_{0ij} = \beta_{00j} + \beta_{01j} \cdot \text{Idade}_{ij} + r_{0ij}$$
$$\pi_{1ij} = \beta_{10j} + r_{1ij}$$

Nível 3 (comunidade):
$$\beta_{00j} = \gamma_{000} + \gamma_{001} \cdot \text{Tamanho}_{j} + u_{00j}$$
$$\beta_{10j} = \gamma_{100} + u_{10j}$$

onde:
- $e_{tij}$ = erro de nível 1 (dentro de indivíduo)
- $r_{0ij}, r_{1ij}$ = efeitos aleatórios de nível 2 (entre indivíduos)
- $u_{00j}, u_{10j}$ = efeitos aleatórios de nível 3 (entre comunidades)

\textbf{Avaliação de Ajuste do Modelo:}
- Coeficiente de Correlação Intraclasse (ICC) para quantificar variância entre níveis
- Comparação de modelos via Likelihood Ratio Test
- Critérios de informação: AIC (Akaike) e BIC (Bayesian)
- Análise de resíduos em cada nível
```

---

### 📌 **Seção Adicional 2: Análise de Sensibilidade e Robustez**

```latex
\subsubsection{Análise de Sensibilidade e Testes de Robustez}

Para avaliar a estabilidade dos resultados, serão conduzidas análises de sensibilidade 
sistemáticas:

\textbf{1. Sensibilidade a Especificações do Modelo:}
- Comparar resultados com diferentes especificações de variáveis de controle
- Testar formas funcionais alternativas (linear, logarítmica, quadrática)
- Avaliar sensibilidade a outliers mediante:
  - Regressão robusta (M-estimadores, Huber, Tukey bisquare)
  - Winsorização de valores extremos
  - Análise com e sem outliers identificados

\textbf{2. Sensibilidade a Missing Data:}
- Comparar resultados de complete case analysis, multiple imputation, e maximum 
  likelihood sob diferentes pressupostos (MAR, MNAR)
- Pattern-mixture models para investigar impacto de padrões de missingness
- Análise de tipping point: quão extremos precisariam ser os valores faltantes 
  para reverter conclusões?

\textbf{3. Sensibilidade a Supostos de Causalidade:}
- Análise de bounds (Manski bounds) para efeitos causais sob diferentes supostos
- Sensibilidade do DiD ao relaxamento de tendências paralelas
- E-values para quantificar força de confundimento não-medido necessária para 
  anular associações observadas

\textbf{4. Cross-validation e Validação Externa:}
- Além de validação interna (k-fold CV), buscar oportunidades de validação 
  externa do modelo em comunidades não participantes da calibração
- Reportar métricas de generalização: queda de desempenho entre treino e teste

\textbf{Documentação da Robustez:}
Resultados das análises de sensibilidade serão apresentados em tabelas e gráficos 
comparativos, discutindo implicações de variações. Conclusões serão consideradas 
robustas apenas se mantiverem direção e significância sob diferentes especificações 
razoáveis.
```

---

### 📌 **Seção Adicional 3: Análise Bayesiana Complementar**

```latex
\subsubsection{Abordagem Bayesiana para Incerteza e Inferência}

Para complementar a inferência frequentista, será aplicada abordagem bayesiana em 
análises selecionadas, particularmente quando:
- Tamanhos amostrais forem limitados
- Informação a priori relevante estiver disponível (ex: estudos prévios)
- Deseja-se incorporar explicitamente incerteza em parâmetros

\textbf{Especificação de Modelos Bayesianos:}
- Prioris: utilizaremos prioris fracamente informativas (weakly informative priors) 
  para evitar influência excessiva, mas regularizar estimação
- Exemplo: $\beta \sim \text{Normal}(0, 10)$ para coeficientes de regressão
- Amostragem: MCMC via algoritmo Hamiltonian Monte Carlo (Stan/PyMC)
- Convergência: verificação via R-hat < 1.01, effective sample size > 1000

\textbf{Inferência e Interpretação:}
- Estimativas pontuais: médias posteriores
- Incerteza: intervalos de credibilidade de 95% (Highest Density Intervals)
- Probabilidades posteriores de hipóteses: P(β > 0 | dados)
- Fatores de Bayes para comparação de modelos

\textbf{Vantagens da Abordagem:}
- Interpretação probabilística direta de parâmetros
- Incorporação natural de estruturas hierárquicas
- Flexibilidade para modelos complexos não-padrão
- Quantificação completa de incerteza
```

---

## 8️⃣ **CHECKLIST DE IMPLEMENTAÇÃO**

### ✅ **Prioridade ALTA** (Implementar imediatamente):

- [ ] **Adicionar cálculo de poder estatístico e tamanho amostral**
- [ ] **Especificar testes de pressupostos antes de testes paramétricos**
- [ ] **Incluir correção para múltiplas comparações (Bonferroni/FDR)**
- [ ] **Reportar tamanhos de efeito além de valores-p**
- [ ] **Adicionar intervalos de confiança para todas as estimativas**
- [ ] **Especificar tratamento de dados faltantes (missing data)**
- [ ] **Incluir análise de sensibilidade**

### ⚙️ **Prioridade MÉDIA** (Implementar se recursos permitirem):

- [ ] **Adicionar modelagem hierárquica (mixed-effects models)**
- [ ] **Incluir análise de mediação e moderação**
- [ ] **Implementar validação cruzada estratificada para ML**
- [ ] **Adicionar confiabilidade inter-avaliadores (Kappa, Alpha)**
- [ ] **Incluir testes de permutação para métricas de rede**
- [ ] **Adicionar análise de equações estruturais (SEM)**

### 🔬 **Prioridade BAIXA** (Adicionar para sofisticação extra):

- [ ] **Análise Bayesiana complementar**
- [ ] **Modelos de redes temporais (TERGM)**
- [ ] **Análise de curvas de crescimento latente**
- [ ] **Meta-análise de múltiplas comunidades**

---

## 9️⃣ **FERRAMENTAS E SOFTWARE RECOMENDADOS**

### 📊 **Para Análise Estatística:**
- **R:** `lme4`, `nlme` (modelos mistos), `lavaan` (SEM), `igraph` (redes)
- **Python:** `statsmodels`, `scipy`, `networkx`, `scikit-learn`
- **Stata:** Para econometria e DiD
- **SPSS:** Para análises mais básicas e familiaridade geral

### 🤖 **Para Machine Learning:**
- **Python:** `scikit-learn`, `xgboost`, `shap`, `lime`
- **R:** `caret`, `mlr3`, `iml` (interpretable ML)

### 📝 **Para Análise Qualitativa:**
- **NVivo 14:** Codificação e análise temática
- **ATLAS.ti:** Alternativa robusta
- **MAXQDA:** Interface amigável
- **R:** `RQDA` package (gratuito, open-source)

### 📈 **Para Visualização:**
- **R:** `ggplot2`, `plotly`, `visNetwork` (redes)
- **Python:** `matplotlib`, `seaborn`, `plotly`
- **Gephi:** Visualização de redes sociais

---

## 🔟 **EXEMPLO DE TEXTO REVISADO**

### ❌ **ANTES** (vago, sem rigor estatístico):
```tex
Para os componentes computacionais e de machine learning, serão realizados 
testes de desempenho rigorosos contemplando múltiplas dimensões: acurácia 
preditiva será avaliada via validação cruzada de k-fold...
```

### ✅ **DEPOIS** (específico, rigoroso estatisticamente):
```tex
Para os componentes computacionais e de machine learning, serão realizados 
testes de desempenho rigorosos contemplando múltiplas dimensões. A acurácia 
preditiva será avaliada via validação cruzada estratificada de 10-fold, 
repetida 5 vezes para estabilidade das estimativas. Além da acurácia global, 
serão calculadas precisão, revocação, F1-score, especificidade e balanced 
accuracy. Para classificação binária, será construída curva ROC e calculada 
a AUC com intervalo de confiança de 95% via método DeLong. O desempenho do 
modelo proposto será comparado estatisticamente com três baselines (regressão 
logística, random forest, naive Bayes) mediante teste de McNemar com correção 
de Bonferroni para múltiplas comparações (α ajustado = 0.05/3 = 0.0167). 
Tamanhos de efeito serão reportados como diferenças absolutas em AUC. 
Análise de sensibilidade investigará robustez a variações em hiperparâmetros 
mediante grid search com validação cruzada aninhada.
```

---

## 📚 **REFERÊNCIAS RECOMENDADAS PARA ADICIONAR**

### Estatística e Metodologia:
- Cohen, J. (1988). *Statistical Power Analysis for the Behavioral Sciences* (2nd ed.)
- Field, A. (2018). *Discovering Statistics Using IBM SPSS Statistics* (5th ed.)
- Gelman, A., & Hill, J. (2006). *Data Analysis Using Regression and Multilevel/Hierarchical Models*
- Imbens, G. W., & Rubin, D. B. (2015). *Causal Inference for Statistics, Social, and Biomedical Sciences*

### Análise de Redes:
- Wasserman, S., & Faust, K. (1994). *Social Network Analysis: Methods and Applications*
- Newman, M. E. J. (2018). *Networks* (2nd ed.)
- Borgatti, S. P., Everett, M. G., & Johnson, J. C. (2018). *Analyzing Social Networks* (2nd ed.)

### Machine Learning e Validação:
- Hastie, T., Tibshirani, R., & Friedman, J. (2009). *The Elements of Statistical Learning* (2nd ed.)
- James, G., Witten, D., Hastie, T., & Tibshirani, R. (2021). *An Introduction to Statistical Learning* (2nd ed.)
- Molnar, C. (2022). *Interpretable Machine Learning* (online book)

### Análise Qualitativa:
- Braun, V., & Clarke, V. (2006). Using thematic analysis in psychology. *Qualitative Research in Psychology*, 3(2), 77-101.
- Miles, M. B., Huberman, A. M., & Saldaña, J. (2019). *Qualitative Data Analysis: A Methods Sourcebook* (4th ed.)

---

## ✅ **CONCLUSÃO E PRÓXIMOS PASSOS**

### Implementação Recomendada:
1. **Fase 1 (1-2 semanas):** Revisar Met_gestao_pi.tex com melhorias de Prioridade ALTA
2. **Fase 2 (2-3 semanas):** Revisar Met_validacao.tex com melhorias de Prioridade ALTA
3. **Fase 3 (1 semana):** Adicionar seções novas (dados hierárquicos, sensibilidade)
4. **Fase 4 (contínuo):** Implementar melhorias de Prioridade MÉDIA conforme possível

### Impacto Esperado:
✅ **Rigor metodológico significativamente aumentado**  
✅ **Credibilidade científica fortalecida**  
✅ **Replicabilidade claramente estabelecida**  
✅ **Inferências causais mais robustas**  
✅ **Validação mais confiável e transparente**

---

**Documento preparado por:** Assistente de Análise Estatística  
**Data:** 25/10/2025  
**Status:** Pronto para implementação
