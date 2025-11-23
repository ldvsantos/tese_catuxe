
# VALIDAÇÃO RÁPIDA DO NOVO CORPUS
# Execute após baixar os arquivos .bib

library(bib2df)
library(tidyverse)

arquivos <- list.files(pattern = "(scopus|wos).*etnografia.*\.bib$")

if (length(arquivos) == 0) {
  stop("Nenhum arquivo encontrado. Baixe primeiro os resultados das buscas.")
}

cat("Processando", length(arquivos), "arquivo(s):\n")

# Ler arquivos
dados <- lapply(arquivos, function(f) {
  cat("  -", f, "\n")
  bib2df(f)
})

bib_df <- bind_rows(dados) %>%
  distinct(TITLE, .keep_all = TRUE)

cat("\nTotal de estudos únicos:", nrow(bib_df), "\n\n")

# Análise rápida dos primeiros 50 títulos
titulos <- tolower(bib_df$TITLE[1:min(50, nrow(bib_df))])

cat("ANÁLISE DOS PRIMEIROS 50 TÍTULOS:\n")
cat("ML terms:", sum(grepl("machine learning|artificial intelligence|algorithm", titulos)), "\n")
cat("TK terms:", sum(grepl("traditional|indigenous|ethnobotany", titulos)), "\n")
cat("Ethno terms:", sum(grepl("ethnograph|qualitative|participatory", titulos)), "\n\n")

cat("Exemplos de títulos:\n")
print(head(bib_df$TITLE, 10))

