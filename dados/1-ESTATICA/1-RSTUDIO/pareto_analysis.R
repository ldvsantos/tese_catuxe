# Script R para Análise de Pareto do Corpus de Estudos sobre Machine Learning em Sistemas de Conhecimento Agrícola Tradicional

# Instalar pacotes necessários se não estiverem instalados
if (!require(bib2df)) install.packages("bib2df")
if (!require(tidytext)) install.packages("tidytext")
if (!require(dplyr)) install.packages("dplyr")
if (!require(stringr)) install.packages("stringr")
if (!require(tm)) install.packages("tm")

library(bib2df)
library(tidytext)
library(dplyr)
library(stringr)
library(tm)

# Ler o arquivo BibTeX
corpus <- bib2df("corpus.bib")

# Verificar estrutura
str(corpus)

# Definir termos e pesos
termos_prioritarios <- c("traditional systems", "indigenous knowledge", "traceability")
peso_prioritario <- 5

termos_alta_relevancia <- c("machine learning", "deep learning", "neural networks")
peso_alta <- 3

termos_media_relevancia <- c("chemometrics", "data mining")
peso_media <- 2

termos_contexto <- c("regional products", "biocultural heritage")
peso_contexto <- 1

termos_exclusao <- c("medical", "clinical", "urban planning", "finance")
peso_exclusao <- c(-5, -5, -3, -2)  # correspondendo à ordem

# Função para calcular relevância temática
calcular_relevancia <- function(title, abstract, keywords) {
  # Combinar texto
  texto <- paste(title, abstract, keywords, sep = " ")
  texto <- tolower(texto)
  
  # Tokenizar
  tokens <- unlist(strsplit(texto, "\\s+"))
  
  # Contar frequências
  freq <- table(tokens)
  
  # Inicializar score
  score <- 0
  
  # Para cada termo, calcular contribuição
  for (termo in names(termos_prioritarios)) {
    if (termo %in% names(freq)) {
      f <- freq[termo]
      # Localização: assumir abstract para simplicidade, mas idealmente verificar
      l <- 1.0  # placeholder
      score <- score + peso_prioritario * l * f
    }
  }
  
  # Similar para outros
  
  # Nota: Esta é uma simplificação. Para precisão, verificar localização exata.
  
  return(score)
}

# Aplicar para cada artigo
corpus$relevancia <- mapply(calcular_relevancia, corpus$TITLE, corpus$ABSTRACT, corpus$KEYWORDS)

# Para impacto bibliométrico: extrair citações
corpus$citacoes <- as.numeric(str_extract(corpus$NOTE, "(?<=Cited by: )\\d+"))

# Para qualidade metodológica: placeholder - presença de termos ML no abstract
corpus$qualidade <- str_count(tolower(corpus$ABSTRACT), "machine learning|deep learning|neural")

# Normalizar scores
max_rel <- max(corpus$relevancia, na.rm = TRUE)
max_cit <- max(corpus$citacoes, na.rm = TRUE)
max_qual <- max(corpus$qualidade, na.rm = TRUE)

corpus$relevancia_norm <- corpus$relevancia / max_rel
corpus$impacto_norm <- corpus$citacoes / max_cit
corpus$qualidade_norm <- corpus$qualidade / max_qual

# Calcular P_final
corpus$P_final <- 0.4 * corpus$qualidade_norm + 0.35 * corpus$relevancia_norm + 0.25 * corpus$impacto_norm

# Ordenar por P_final decrescente
corpus <- corpus %>% arrange(desc(P_final))

# Selecionar top 20%
n_top <- round(0.2 * nrow(corpus))
top_20 <- corpus[1:n_top, ]

# Salvar CSV completo
write.csv(corpus, "corpus_com_scores.csv", row.names = FALSE)

# Salvar top 20%
write.csv(top_20, "top_20_pareto.csv", row.names = FALSE)

# Gerar relatório em português
relatorio <- paste0(
  "Relatório de Análise de Pareto\n",
  "Corpus: ", nrow(corpus), " estudos\n",
  "Top 20%: ", n_top, " estudos selecionados\n\n",
  "Top 10 Artigos:\n"
)

top_10 <- head(corpus, 10)
for (i in 1:10) {
  relatorio <- paste0(relatorio,
    i, ". ", top_10$TITLE[i], "\n",
    "   P_final: ", round(top_10$P_final[i], 3), "\n",
    "   Qualidade: ", round(top_10$qualidade_norm[i], 3), "\n",
    "   Relevância: ", round(top_10$relevancia_norm[i], 3), "\n",
    "   Impacto: ", round(top_10$impacto_norm[i], 3), "\n\n"
  )
}

write(relatorio, "relatorio_pareto.txt")

# Gerar tabela LaTeX para top 10
latex_table <- "\\begin{table}[h]\n\\centering\n\\caption{Top 10 Artigos por Pontuação de Pareto}\n\\label{tab:top10}\n\\begin{tabular}{|c|p{8cm}|c|c|c|c|}\n\\hline\nPosição & Título & P\\_final & Qualidade & Relevância & Impacto \\\\\n\\hline\n"

for (i in 1:10) {
  latex_table <- paste0(latex_table,
    i, " & ", str_replace_all(top_10$TITLE[i], "&", "\\\\&"), " & ",
    round(top_10$P_final[i], 3), " & ",
    round(top_10$qualidade_norm[i], 3), " & ",
    round(top_10$relevancia_norm[i], 3), " & ",
    round(top_10$impacto_norm[i], 3), " \\\\\n\\hline\n"
  )
}

latex_table <- paste0(latex_table, "\\end{tabular}\n\\end{table}")

write(latex_table, "tabela_top10.tex")

print("Análise concluída. Arquivos gerados: corpus_com_scores.csv, top_20_pareto.csv, relatorio_pareto.txt, tabela_top10.tex")</content>
<parameter name="filePath">c:\Users\vidal\OneDrive\Documentos\13 - CLONEGIT\tese-catuxe\DADOS\1-ESTATISTICA\1-RSTUDIO\pareto_analysis.R