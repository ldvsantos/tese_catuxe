# 📊 Índice de Diagramas do Projeto

> **Localização:** `CONTEUDOS/METODOLOGIA/PROCESSO/diagramas/`

## 🎯 Acesso Rápido

### 1. 📌 **[Fluxo das 6 Etapas](fluxo-6-etapas.md)**
Mostra o fluxo sequencial da pesquisa de forma clara e visual.

**Casos de uso:**
- Apresentação inicial do projeto
- Visão geral da metodologia
- Comunicação com stakeholders
- Seção de Metodologia na tese

**Elementos:**
- 6 etapas principais (cores diferenciadas)
- Fluxo de dados entre etapas
- Timeline indicativa
- Relação com objetivos

[👉 Abrir Diagram](fluxo-6-etapas.md)

---

### 2. 🔄 **[Módulos Integrados](modulos-integrados.md)**
Arquitetura dos 5 módulos metodológicos e como se integram.

**Casos de uso:**
- Explicar como diferentes métodos trabalham juntos
- Detalhes técnicos de cada módulo
- Especificação de atividades
- Integração entre metodologias

**Elementos:**
- 5 módulos (RS, Coleta, Psico, ML, PI)
- Atividades de cada módulo
- Conexões entre módulos
- Matriz de relação módulos-etapas

[👉 Abrir Diagram](modulos-integrados.md)

---

### 3. 🎯 **[Objetivos, Questões & Hipóteses](objetivos-especificos.md)**
Alinhamento entre 4 Objetivos Específicos, 4 Questões e 4 Hipóteses.

**Casos de uso:**
- Fundamentação da pesquisa
- Introdução da tese
- Apresentação de critérios de sucesso
- Estrutura lógica da evidência

**Elementos:**
- 4 Objetivos Específicos (OE1-OE4)
- 4 Questões de Pesquisa (Q1-Q4)
- 4 Hipóteses (H1-H4)
- Dimensões de cada objetivo
- Critérios de sucesso

[👉 Abrir Diagram](objetivos-especificos.md)

---

### 4. 📅 **[Timeline - 36 Meses](timeline-projeto.md)**
Cronograma detalhado do projeto com milestones críticos.

**Casos de uso:**
- Planejamento e acompanhamento
- Apresentação de escopo temporal
- Contingências e riscos
- Distribuição de esforço

**Elementos:**
- Diagrama de Gantt
- Cronograma por trimestre
- Milestones críticos
- Indicadores de progresso
- Planos de contingência

[👉 Abrir Diagram](timeline-projeto.md)

---

## 🌟 Como Explorar os Diagramas

### 📱 **No GitHub (Recomendado)**
1. Clique em um arquivo `.md` acima
2. O diagrama renderiza automaticamente
3. Você pode ver o código Mermaid no final
4. Fácil compartilhar via link

### 💻 **Localmente no VS Code**

#### Opção A: Preview
1. Abra o arquivo `.md`
2. Clique em "Preview" ou use `Ctrl+Shift+V`
3. Veja o diagrama renderizado

#### Opção B: Instalar Extensão
1. Vá para Extensions
2. Procure: "Markdown Preview Mermaid Support"
3. Instale (vsls-contrib.markdown-mermaid)
4. Abra qualquer `.md` em preview

### 🌐 **Online (Mermaid Live Editor)**
1. Abra https://mermaid.live
2. Copie o código Mermaid do arquivo
3. Cole no editor online
4. Customize cores e layout em tempo real
5. Exporte como SVG/PNG

---

## 📚 Estrutura dos Documentos

Cada arquivo de diagrama segue este padrão:

```markdown
# 📊 Título

## Descrição
Explicação do que o diagrama mostra

## Diagrama Principal
```mermaid
[código Mermaid]
```

## 📝 Descrição Detalhada
Explicação de cada elemento

## 🔗 Relações
Como se conecta com outros diagramas

## 💾 Como Usar
Instruções de visualização e edição
```

---

## 🎨 Cores & Significado

### Cores nos Diagramas

| Cor | Significado | Exemplo |
|-----|-------------|---------|
| 🟢 Verde | Início/Fim, Sucesso | Projeto Aprovado |
| 🔵 Azul | Coleta de Dados | Revisão Sistemática |
| 🟡 Amarelo | Validação | Análise Psicométrica |
| 🟠 Laranja | Aplicação | Gestão de PI |
| 🟣 Roxo | Integração/Consolidação | Etapa 6 |
| 🔴 Vermelho | Crítico/Objetivo Geral | Objetivo Geral |

---

## 🔄 Como os Diagramas se Relacionam

```
                          Objetivo Geral
                                ↓
            ┌───────────────────┼───────────────────┐
            ↓                   ↓                   ↓
      OE1-Q1-H1          OE2-Q2-H2          OE3-Q3-H3     OE4-Q4-H4
            ↓                   ↓                   ↓                ↓
      ┌─────────────────────────┴──────────────────┼────────────────┘
      ↓                                            ↓
  E1→E2→E3→E4→E5→E6 (Fluxo das 6 Etapas)    Timeline (36 meses)
      ↓
  RS | Coleta | Psico | ML | PI | Integração (Módulos)
      ↓
  Framework Final Validado
```

---

## ✨ Dicas de Uso

### 1. **Para Apresentações**
- Use o fluxo das 6 etapas como visão geral
- Detalhe com módulos integrados
- Mostre alinhamento OE-Q-H para fundamentação
- Timeline para mostrar realismo/viabilidade

### 2. **Para a Tese**
```latex
% No documento LaTeX
\section{Metodologia}

% Usar fluxo das 6 etapas
\begin{figure}[H]
    \includegraphics[width=0.9\textwidth]{diagramas/fluxo-6-etapas.svg}
    \caption{Etapas da pesquisa}
\end{figure}

% Detalhar módulos
\begin{figure}[H]
    \includegraphics[width=0.9\textwidth]{diagramas/modulos-integrados.svg}
    \caption{Módulos metodológicos integrados}
\end{figure}
```

### 3. **Para Comunicação**
- Gere PNG para slides
- Gere SVG para inserir em documentos
- Compartilhe links diretos do GitHub
- Use em email/chat para explicar estrutura

### 4. **Para Monitoramento**
- Mantenha a timeline atualizada
- Use como checkpoint de progresso
- Sinalize atrasos vs. planejado
- Ajuste cronograma conforme necessário

---

## 🛠️ Exportar Diagramas como Imagens

### Instalar ferramenta (uma única vez)
```bash
npm install -g @mermaid-js/mermaid-cli
```

### Gerar SVG (melhor para documentos)
```bash
mmdc -i fluxo-6-etapas.md -o fluxo-6-etapas.svg
mmdc -i modulos-integrados.md -o modulos-integrados.svg
mmdc -i objetivos-especificos.md -o objetivos-especificos.svg
mmdc -i timeline-projeto.md -o timeline-projeto.svg
```

### Gerar PNG (melhor para apresentações)
```bash
mmdc -i fluxo-6-etapas.md -o fluxo-6-etapas.png
mmdc -i modulos-integrados.md -o modulos-integrados.png
mmdc -i objetivos-especificos.md -o objetivos-especificos.png
mmdc -i timeline-projeto.md -o timeline-projeto.png
```

### Gerar com tema escuro
```bash
mmdc -i fluxo-6-etapas.md -o fluxo-6-etapas-dark.svg -t dark
```

---

## 📊 Matriz de Rastreabilidade

Mapeia cada elemento do projeto a seus diagramas:

```
Objetivo    Q1    Q2    Q3    Q4    E1    E2    E3    E4    E5    E6
─────────────────────────────────────────────────────────────────────
OE1          ✓                 ✓     ✓     ✓
OE2               ✓            ✓           ✓     ✓
OE3                    ✓            ✓           ✓     ✓
OE4                         ✓                         ✓     ✓     ✓

Módulo      FL    OQ    TL
─────────────────────────
RS          ✓     ✓     ✓
Coleta      ✓     ✓     ✓
Psico       ✓     ✓     ✓
ML          ✓     ✓     ✓
PI          ✓     ✓     ✓
```

**Legenda:**
- OQ = Objetivos & Questões
- TL = Timeline
- FL = Fluxo

---

## 🔍 Busca Rápida

**Procurando por...**

- ❓ Como o projeto está estruturado? → [Fluxo das 6 Etapas](fluxo-6-etapas.md)
- 🔄 Como os métodos se conectam? → [Módulos Integrados](modulos-integrados.md)
- 🎯 Qual é a lógica de pesquisa? → [Objetivos & Hipóteses](objetivos-especificos.md)
- 📅 Quanto tempo vai levar? → [Timeline](timeline-projeto.md)
- 🛠️ Como criar diagramas? → [README](README.md)

---

## 💾 Manutenção dos Diagramas

### Quando Atualizar
- [ ] Mudanças no escopo (etapas, módulos)
- [ ] Alterações cronológicas (datas, milestones)
- [ ] Novos objetivos ou hipóteses
- [ ] Refinamento de metodologia

### Como Atualizar
1. Abra o arquivo `.md` em seu editor
2. Modifique o código Mermaid
3. Teste em https://mermaid.live
4. Salve o arquivo
5. Faça commit: `git commit -m "update: diagram [name] - reason"`
6. Push: `git push origin main`

### Versionamento
- Versão 1.0: Estrutura inicial (2025-01)
- Versão 1.1: Ajustes pós-coleta
- Versão 2.0: Incluir resultados preliminares
- Versão 3.0: Framework final

---

## 🎓 Recursos Adicionais

- 📖 [Documentação Mermaid.js](https://mermaid.js.org)
- 🎨 [Mermaid Live Editor](https://mermaid.live)
- 💡 [Exemplos de Flowcharts](https://mermaid.js.org/syntax/flowchart.html)
- 📚 [Guia de Ferramentas](GUIA_FERRAMENTAS_FLUXOGRAMAS.md)
- 📋 [README da pasta diagrams](README.md)

---

## 📋 Checklist de Uso

- [ ] Já visualizei todos os 4 diagramas?
- [ ] Entendo como eles se conectam?
- [ ] Exportei em SVG/PNG para usar na tese?
- [ ] Compartilhei com minha banca/orientador?
- [ ] Usei como referência de cronograma?
- [ ] Atualizei conforme progresso real?

---

## 🤝 Feedback & Sugestões

Se os diagramas precisa de:
- Correções
- Esclarecimentos
- Novos elementos
- Adaptações

Por favor, abra uma issue ou faça um commit com as sugestões!

---

**Criado em:** 2025  
**Última atualização:** 2025-01  
**Versão:** 1.0  
**Status:** Ativo ✅

**Próximas Versões:**
- v1.1: Incluir resultados preliminares (após E2)
- v2.0: Atualizar com descobertas de cada etapa
- v3.0: Framework final e recomendações

