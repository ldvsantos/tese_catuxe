################################################################################
# TIME SERIES ANALYSIS (2010-2025) - GGPLOT2
# Machine Learning for Geographical Indications
#
# This script performs temporal analysis using ggplot2
# and generates elegant visualizations
#
# Outputs:
#   - temporal_publicacoes.png (Evolution of publications)
#   - temporal_algoritmos.png (Algorithm adoption)
#   - temporal_produtos.png (Product evolution)
#   - temporal_regioes.png (Geographic distribution)
#   - temporal_heatmap.png (Evolution heatmap)
#   - temporal_tendencias.png (Trend analysis)
#   - temporal_relatorio.txt (Complete analysis)
#   - temporal_*.csv (Processed data)
################################################################################

rm(list = ls())
gc()

packages <- c("bib2df", "tidyverse", "viridis", "patchwork", "scales", 
              "ggrepel", "pheatmap", "lubridate")

for (pkg in packages) {
  if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
    install.packages(pkg, dependencies = TRUE, repos = "https://cloud.r-project.org")
    library(pkg, character.only = TRUE)
  }
}

cat("\n")
cat("================================================================================\n")
cat("TIME SERIES ANALYSIS (2010-2025) - GGPLOT2\n")
cat("Machine Learning para Conhecimentos Tradicionais\n")
cat("================================================================================\n\n")

################################################################################
# FUNÇÃO: Extrair dados temporais
################################################################################
extrair_dados_temporais <- function(caminho_bib) {
  cat("📚 Extracting temporal data from .bib file...\n")
  
  bib_data <- bib2df(caminho_bib)
  texto_completo <- tolower(paste(bib_data$TITLE, bib_data$ABSTRACT, bib_data$KEYWORDS, sep = " "))
  
  dados <- data.frame(
    ID = 1:nrow(bib_data),
    Ano = as.numeric(bib_data$YEAR),
    
    # Algoritmos ML
    RandomForest = as.integer(grepl("random forest", texto_completo)),
    SVM = as.integer(grepl("svm|support vector", texto_completo)),
    NeuralNetwork = as.integer(grepl("neural|deep learning|cnn|lstm", texto_completo)),
    KNN = as.integer(grepl("k-nearest|knn", texto_completo)),
    DecisionTree = as.integer(grepl("decision tree", texto_completo)),
    NLP = as.integer(grepl("natural language processing|nlp\\b", texto_completo)),
    
    # Métodos Etnográficos
    Ethnography = as.integer(grepl("ethnography|ethnographic", texto_completo)),
    Interview = as.integer(grepl("interview|semi-structured|oral history", texto_completo)),
    Participatory = as.integer(grepl("participatory|community-based", texto_completo)),
    
    # Conhecimentos Tradicionais
    TraditionalKnowledge = as.integer(grepl("traditional knowledge|indigenous knowledge", texto_completo)),
    Ethnobotany = as.integer(grepl("ethnobotany|medicinal plants", texto_completo)),
    IndigenousPeoples = as.integer(grepl("indigenous|native people", texto_completo)),
    
    # Agroecologia
    Agroecology = as.integer(grepl("agroecology|sustainable agriculture", texto_completo)),
    Biodiversity = as.integer(grepl("biodiversity|conservation", texto_completo)),
    TraditionalFarming = as.integer(grepl("traditional farming", texto_completo)),
    
    # Regiões
    LatinAmerica = as.integer(grepl("latin america|brazil|mexico|amazon", texto_completo)),
    Africa = as.integer(grepl("africa|african", texto_completo)),
    Asia = as.integer(grepl("asia|india|china|indonesia", texto_completo)),
    Europe = as.integer(grepl("europe|european", texto_completo)),
    
    stringsAsFactors = FALSE
  )
  
  # Filtrar anos válidos
  dados <- dados %>% filter(Ano >= 2016, Ano <= 2025)
  
  cat(sprintf("✓ Total studies extracted: %d (2016-2025)\n\n", nrow(dados)))
  
  return(dados)
}

################################################################################
# FUNÇÃO: Agregar por ano
################################################################################
agregar_por_ano <- function(dados) {
  cat("🔬 Agregando dados por ano...\n")
  
  # Total publications per year
  publicacoes_ano <- dados %>%
    group_by(Ano) %>%
    summarise(Total = n(), .groups = "drop")
  
  # Algorithms per year
  algoritmos_ano <- dados %>%
    group_by(Ano) %>%
    summarise(
      RandomForest = sum(RandomForest),
      SVM = sum(SVM),
      NeuralNetwork = sum(NeuralNetwork),
      KNN = sum(KNN),
      DecisionTree = sum(DecisionTree),
      NLP = sum(NLP),
      .groups = "drop"
    )
  
  # Ethnographic Methods per year
  metodos_ano <- dados %>%
    group_by(Ano) %>%
    summarise(
      Ethnography = sum(Ethnography),
      Interview = sum(Interview),
      Participatory = sum(Participatory),
      .groups = "drop"
    )
  
  # Traditional Knowledge Topics per year
  temas_ano <- dados %>%
    group_by(Ano) %>%
    summarise(
      TraditionalKnowledge = sum(TraditionalKnowledge),
      Ethnobotany = sum(Ethnobotany),
      IndigenousPeoples = sum(IndigenousPeoples),
      Agroecology = sum(Agroecology),
      Biodiversity = sum(Biodiversity),
      TraditionalFarming = sum(TraditionalFarming),
      .groups = "drop"
    )
  
  # Regions per year
  regioes_ano <- dados %>%
    group_by(Ano) %>%
    summarise(
      LatinAmerica = sum(LatinAmerica),
      Africa = sum(Africa),
      Asia = sum(Asia),
      Europe = sum(Europe),
      .groups = "drop"
    )
  
  cat("✓ Aggregation completed\n\n")
  
  return(list(
    publicacoes = publicacoes_ano,
    algoritmos = algoritmos_ano,
    metodos = metodos_ano,
    temas = temas_ano,
    regioes = regioes_ano
  ))
}

################################################################################
# FUNÇÃO: Plot de publicações ao longo do tempo
################################################################################
plot_publicacoes_tempo <- function(publicacoes_ano, output_file = "temporal_publicacoes.png") {
  cat("📊 Generating publications chart...\n")
  
  p <- ggplot(publicacoes_ano, aes(x = Ano, y = Total)) +
    geom_line(color = "#2E86AB", size = 1.5) +
    geom_point(color = "#2E86AB", size = 4, alpha = 0.8) +
    geom_smooth(method = "loess", se = TRUE, color = "#FC4E07", 
                fill = "#FC4E07", alpha = 0.2, linetype = "dashed") +
    scale_x_continuous(breaks = seq(2016, 2025, 1), limits = c(2016, 2025)) +
    labs(
      title = "Evolução das Publicações em ML para Conhecimentos Tradicionais",
      subtitle = "Período: 2016-2025",
      x = "Ano",
      y = "Número de Publicações",
      caption = "Linha tracejada: tendência LOESS"
    ) +
    theme_minimal(base_size = 14) +
    theme(
      plot.title = element_text(face = "bold", size = 16, hjust = 0.5),
      plot.subtitle = element_text(hjust = 0.5, color = "gray40"),
      panel.grid.minor = element_blank()
    )
  
  ggsave(output_file, plot = p, width = 12, height = 7, dpi = 300)
  cat(sprintf("✓ Publications chart saved: %s\n", output_file))
}

################################################################################
# FUNÇÃO: Plot de algoritmos ao longo do tempo
################################################################################
plot_algoritmos_tempo <- function(algoritmos_ano, output_file = "temporal_algoritmos.png") {
  cat("📊 Generating algorithms chart...\n")
  
  algoritmos_long <- algoritmos_ano %>%
    pivot_longer(-Ano, names_to = "Algoritmo", values_to = "Frequencia")
  
  p <- ggplot(algoritmos_long, aes(x = Ano, y = Frequencia, color = Algoritmo, group = Algoritmo)) +
    geom_line(size = 1.2, alpha = 0.8) +
    geom_point(size = 2.5, alpha = 0.7) +
    scale_x_continuous(breaks = seq(2010, 2025, 1)) +
    scale_color_viridis_d(option = "plasma", begin = 0.1, end = 0.9) +
    labs(
      title = "Evolução Temporal da Adoção de Algoritmos de Machine Learning (2010–2025)",
      subtitle = "Frequência de uso em estudos de Conhecimentos Tradicionais por ano",
      x = "Ano de Publicação",
      y = "Frequência Absoluta",
      color = "Algoritmo"
    ) +
    theme_minimal(base_size = 14) +
    theme(
      plot.title = element_text(face = "bold", size = 16, hjust = 0.5),
      plot.subtitle = element_text(hjust = 0.5, color = "gray40"),
      legend.position = "right",
      panel.grid.minor = element_blank()
    )
  
  ggsave(output_file, plot = p, width = 14, height = 8, dpi = 300)
  cat(sprintf("✓ Algorithms chart saved: %s\n", output_file))
}

################################################################################
# FUNÇÃO: Plot de temas de conhecimento tradicional ao longo do tempo
################################################################################
plot_temas_tempo <- function(temas_ano, output_file = "temporal_temas.png") {
  cat("📊 Generating traditional knowledge themes chart...\n")
  
  temas_long <- temas_ano %>%
    pivot_longer(-Ano, names_to = "Tema", values_to = "Frequencia")
  
  p <- ggplot(temas_long, aes(x = Ano, y = Frequencia, fill = Tema)) +
    geom_area(alpha = 0.7, position = "stack") +
    scale_x_continuous(breaks = seq(2010, 2025, 1)) +
    scale_fill_viridis_d(option = "turbo") +
    labs(
      title = "Evolução Temporal de Temas em Conhecimentos Tradicionais (2010–2025)",
      subtitle = "Frequência cumulativa por categoria temática e ano",
      x = "Ano de Publicação",
      y = "Frequência Cumulativa",
      fill = "Tema"
    ) +
    theme_minimal(base_size = 14) +
    theme(
      plot.title = element_text(face = "bold", size = 16, hjust = 0.5),
      plot.subtitle = element_text(hjust = 0.5, color = "gray40"),
      legend.position = "right",
      panel.grid.minor = element_blank(),
      axis.text.x = element_text(angle = 45, hjust = 1)
    )
  
  ggsave(output_file, plot = p, width = 14, height = 8, dpi = 300)
  cat(sprintf("✓ Themes chart saved: %s\n", output_file))
}

################################################################################
# FUNÇÃO: Plot de métodos etnográficos ao longo do tempo
################################################################################
plot_metodos_tempo <- function(metodos_ano, output_file = "temporal_metodos.png") {
  cat("📊 Generating ethnographic methods chart...\n")
  
  metodos_long <- metodos_ano %>%
    pivot_longer(-Ano, names_to = "Metodo", values_to = "Frequencia")
  
  p <- ggplot(metodos_long, aes(x = Ano, y = Frequencia, color = Metodo, group = Metodo)) +
    geom_line(size = 1.2, alpha = 0.8) +
    geom_point(size = 2.5, alpha = 0.7) +
    scale_x_continuous(breaks = seq(2010, 2025, 1)) +
    scale_color_viridis_d(option = "plasma", begin = 0.1, end = 0.9) +
    labs(
      title = "Evolução Temporal de Métodos Etnográficos (2010–2025)",
      subtitle = "Frequência de uso em estudos por ano",
      x = "Ano de Publicação",
      y = "Frequência Absoluta",
      color = "Método"
    ) +
    theme_minimal(base_size = 14) +
    theme(
      plot.title = element_text(face = "bold", size = 16, hjust = 0.5),
      plot.subtitle = element_text(hjust = 0.5, color = "gray40"),
      legend.position = "right",
      panel.grid.minor = element_blank(),
      axis.text.x = element_text(angle = 45, hjust = 1)
    )
  
  ggsave(output_file, plot = p, width = 14, height = 8, dpi = 300)
  cat(sprintf("✓ Methods chart saved: %s\n", output_file))
}

################################################################################
# FUNÇÃO: Plot de regiões ao longo do tempo
################################################################################
plot_regioes_tempo <- function(regioes_ano, output_file = "temporal_regioes.png") {
  cat("📊 Generating regions chart...\n")
  
  regioes_long <- regioes_ano %>%
    pivot_longer(-Ano, names_to = "Regiao", values_to = "Frequencia")
  
  p <- ggplot(regioes_long, aes(x = Ano, y = Frequencia, color = Regiao, group = Regiao)) +
    geom_line(size = 1.2, alpha = 0.8) +
    geom_point(size = 2.5, alpha = 0.7) +
    scale_x_continuous(breaks = seq(2010, 2025, 1)) +
    scale_color_manual(values = c("Europe" = "#2E86AB", "Asia" = "#FC4E07", 
                                   "Americas" = "#A23B72"),
                       labels = c("Europe" = "Europa", "Asia" = "Ásia", 
                                  "Americas" = "Américas")) +
    labs(
      title = "Distribuição Geográfica de ML em Estudos de CT (2010–2025)",
      subtitle = "Frequência absoluta de publicações por região e ano",
      x = "Ano de Publicação",
      y = "Frequência Absoluta",
      color = "Região Geográfica"
    ) +
    theme_minimal(base_size = 14) +
    theme(
      plot.title = element_text(face = "bold", size = 16, hjust = 0.5),
      plot.subtitle = element_text(hjust = 0.5, color = "gray40"),
      legend.position = "right",
      panel.grid.minor = element_blank()
    )
  
  ggsave(output_file, plot = p, width = 12, height = 7, dpi = 300)
  cat(sprintf("✓ Regions chart saved: %s\n", output_file))
}

################################################################################
# FUNÇÃO: Heatmap de evolução
################################################################################
plot_heatmap_evolucao <- function(dados_temporais, output_file = "temporal_heatmap.png") {
  cat("📊 Generating evolution heatmap...\n")
  
  # Combinar algoritmos e temas
  combined <- dados_temporais$algoritmos %>%
    left_join(dados_temporais$temas, by = "Ano") %>%
    pivot_longer(-Ano, names_to = "Feature", values_to = "Frequencia")
  
  p <- ggplot(combined, aes(x = Ano, y = Feature, fill = Frequencia)) +
    geom_tile(color = "white", size = 0.5) +
    geom_text(aes(label = Frequencia), color = "white", size = 2.5, fontface = "bold") +
    scale_fill_viridis_c(option = "magma", direction = -1) +
    scale_x_continuous(breaks = seq(2010, 2025, 1)) +
    labs(
      title = "Heatmap de Evolução Temporal: Algoritmos ML e Temas de CT",
      subtitle = "Frequência de uso em estudos por ano (2010–2025)",
      x = "Ano de Publicação",
      y = "Feature (Algoritmo ou Tema)",
      fill = "Frequência Absoluta"
    ) +
    theme_minimal(base_size = 12) +
    theme(
      plot.title = element_text(face = "bold", size = 14, hjust = 0.5),
      plot.subtitle = element_text(hjust = 0.5, color = "gray40"),
      axis.text.y = element_text(size = 10),
      legend.position = "right",
      panel.grid = element_blank()
    )
  
  ggsave(output_file, plot = p, width = 14, height = 10, dpi = 300)
  cat(sprintf("✓ Evolution heatmap saved: %s\n", output_file))
}

################################################################################
# FUNÇÃO: Análise de tendências
################################################################################
calcular_tendencias <- function(dados_temporais) {
  cat("🔬 Calculating temporal trends...\n")
  
  tendencias <- list()
  
  # Algoritmos
  for (col in setdiff(names(dados_temporais$algoritmos), "Ano")) {
    df <- dados_temporais$algoritmos %>% select(Ano, all_of(col))
    colnames(df) <- c("Ano", "Valor")
    
    if (sum(df$Valor) >= 5) {  # Mínimo de 5 ocorrências
      cor_test <- cor.test(df$Ano, df$Valor, method = "spearman")
      tendencias[[col]] <- data.frame(
        Feature = col,
        Tipo = "Algoritmo",
        Correlacao = cor_test$estimate,
        PValue = cor_test$p.value,
        Significativo = cor_test$p.value < 0.05,
        Tendencia = ifelse(cor_test$estimate > 0, "Crescente", "Decrescente"),
        stringsAsFactors = FALSE
      )
    }
  }
  
  # Produtos
  for (col in setdiff(names(dados_temporais$produtos), "Ano")) {
    df <- dados_temporais$produtos %>% select(Ano, all_of(col))
    colnames(df) <- c("Ano", "Valor")
    
    if (sum(df$Valor) >= 5) {
      cor_test <- cor.test(df$Ano, df$Valor, method = "spearman")
      tendencias[[col]] <- data.frame(
        Feature = col,
        Tipo = "Produto",
        Correlacao = cor_test$estimate,
        PValue = cor_test$p.value,
        Significativo = cor_test$p.value < 0.05,
        Tendencia = ifelse(cor_test$estimate > 0, "Crescente", "Decrescente"),
        stringsAsFactors = FALSE
      )
    }
  }
  
  tendencias_df <- bind_rows(tendencias)
  tendencias_df <- tendencias_df %>% arrange(desc(abs(Correlacao)))
  
  cat("✓ Trends calculated\n\n")
  
  return(tendencias_df)
}

################################################################################
# FUNÇÃO: Plot de tendências significativas
################################################################################
plot_tendencias <- function(tendencias, output_file = "temporal_tendencias.png") {
  cat("📊 Generating trends chart...\n")
  
  # Filtrar apenas tendências significativas
  tend_sig <- tendencias %>%
    filter(Significativo == TRUE) %>%
    mutate(Feature = reorder(Feature, Correlacao))
  
  if (nrow(tend_sig) == 0) {
    cat("⚠️  No significant trends detected (p < 0.05)\n")
    return(NULL)
  }
  
  p <- ggplot(tend_sig, aes(x = Correlacao, y = Feature, fill = Tipo)) +
    geom_col(alpha = 0.8) +
    geom_vline(xintercept = 0, linetype = "dashed", color = "gray30") +
    scale_fill_viridis_d(option = "plasma", begin = 0.2, end = 0.8) +
    labs(
      title = "Tendências Temporais Estatisticamente Significativas (p < 0.05)",
      subtitle = "Coeficiente de correlação de Spearman (ρ) entre frequência e ano de publicação",
      x = "Correlação de Spearman (ρ)",
      y = "Feature (Algoritmo ou Produto)",
      fill = "Categoria"
    ) +
    theme_minimal(base_size = 14) +
    theme(
      plot.title = element_text(face = "bold", size = 16, hjust = 0.5),
      plot.subtitle = element_text(hjust = 0.5, color = "gray40"),
      legend.position = "right",
      panel.grid.minor = element_blank()
    )
  
  ggsave(output_file, plot = p, width = 12, height = 8, dpi = 300)
  cat(sprintf("✓ Trends chart saved: %s\n", output_file))
}

################################################################################
# FUNÇÃO: Relatório
################################################################################
gerar_relatorio <- function(dados_temporais, tendencias, output_file = "temporal_relatorio.txt") {
  cat("\n📝 Generating statistical report...\n")
  
  sink(output_file)
  cat("================================================================================\n")
  cat("TEMPORAL ANALYSIS REPORT - ML PARA CONHECIMENTOS TRADICIONAIS\n")
  cat("================================================================================\n\n")
  cat(sprintf("Data de execução: %s\n", Sys.time()))
  cat(sprintf("Período analisado: 2010-2025\n\n"))
  
  cat("--------------------------------------------------------------------------------\n")
  cat("PUBLICATIONS EVOLUTION\n")
  cat("--------------------------------------------------------------------------------\n")
  print(dados_temporais$publicacoes)
  cat("\n")
  
  cat("--------------------------------------------------------------------------------\n")
  cat("SIGNIFICANT TEMPORAL TRENDS (p < 0.05)\n")
  cat("--------------------------------------------------------------------------------\n")
  tend_sig <- tendencias %>% filter(Significativo == TRUE)
  if (nrow(tend_sig) > 0) {
    print(tend_sig)
  } else {
    cat("No significant trends detected.\n")
  }
  cat("\n")
  
  cat("--------------------------------------------------------------------------------\n")
  cat("MOST USED ALGORITHMS (2020-2025)\n")
  cat("--------------------------------------------------------------------------------\n")
  alg_recente <- dados_temporais$algoritmos %>%
    filter(Ano >= 2020) %>%
    summarise(across(-Ano, sum)) %>%
    pivot_longer(everything(), names_to = "Algoritmo", values_to = "Total") %>%
    arrange(desc(Total))
  print(alg_recente)
  cat("\n")
  
  cat("--------------------------------------------------------------------------------\n")
  cat("MOST STUDIED PRODUCTS (2020-2025)\n")
  cat("--------------------------------------------------------------------------------\n")
  prod_recente <- dados_temporais$produtos %>%
    filter(Ano >= 2020) %>%
    summarise(across(-Ano, sum)) %>%
    pivot_longer(everything(), names_to = "Produto", values_to = "Total") %>%
    arrange(desc(Total))
  print(prod_recente)
  cat("\n")
  
  cat("================================================================================\n")
  sink()
  
  cat(sprintf("✓ Statistical report saved: %s\n", output_file))
}

################################################################################
# FUNÇÃO: Salvar dados
################################################################################
salvar_dados <- function(dados_temporais, tendencias) {
  write.csv(dados_temporais$publicacoes, "temporal_publicacoes.csv", row.names = FALSE)
  write.csv(dados_temporais$algoritmos, "temporal_algoritmos.csv", row.names = FALSE)
  write.csv(dados_temporais$produtos, "temporal_produtos.csv", row.names = FALSE)
  write.csv(tendencias, "temporal_tendencias.csv", row.names = FALSE)
  
  cat("\n✓ Data saved: temporal_*.csv\n")
}

################################################################################
# FUNÇÃO: Plot temporal por clusters
################################################################################
plot_clusters_tempo <- function(dados_temporais, output_file = "temporal_clusters.png") {
  cat("📊 Gerando evolução temporal por clusters...\n")
  
  # Verificar se arquivo de clusters existe
  cluster_file <- "../3-CLUSTERS/cluster_resultados.csv"
  if (!file.exists(cluster_file)) {
    cat("⚠️  Arquivo de clusters não encontrado. Pulando visualização.\n")
    return(invisible(NULL))
  }
  
  # Carregar clusters e dados originais
  clusters_data <- read.csv(cluster_file)
  caminho_bib <- "../corpus.bib"
  bib_data <- bib2df(caminho_bib)
  
  # Combinar ano com cluster
  dados_cluster_ano <- data.frame(
    Ano = as.numeric(bib_data$YEAR),
    Cluster = clusters_data$Cluster_KMeans[1:nrow(bib_data)]
  ) %>%
    filter(!is.na(Ano), !is.na(Cluster)) %>%
    group_by(Ano, Cluster) %>%
    summarise(Frequencia = n(), .groups = "drop")
  
  # Nomes dos clusters
  cluster_names <- c(
    "1" = "Mineração de Dados e CT",
    "2" = "ML em Conservação",
    "3" = "ML e Povos Indígenas",
    "4" = "Etnobotânica Aplicada",
    "5" = "ML e Mudanças Climáticas"
  )
  
  dados_cluster_ano$Cluster_Label <- cluster_names[as.character(dados_cluster_ano$Cluster)]
  
  # Cores dos clusters
  cores_clusters <- c("#E41A1C", "#377EB8", "#4DAF4A", "#FF7F00", "#984EA3")
  
  # Criar visualização
  p <- ggplot(dados_cluster_ano, aes(x = Ano, y = Frequencia, color = Cluster_Label, group = Cluster_Label)) +
    geom_line(size = 1.2, alpha = 0.8) +
    geom_point(size = 3, alpha = 0.8) +
    scale_color_manual(values = cores_clusters, name = "Grupos Temáticos") +
    scale_x_continuous(breaks = seq(min(dados_cluster_ano$Ano), max(dados_cluster_ano$Ano), by = 1)) +
    labs(
      title = "Evolução Temporal dos Grupos Temáticos",
      subtitle = "Publicações por ano em cada grupo identificado",
      x = "Ano de Publicação",
      y = "Número de Publicações"
    ) +
    theme_minimal(base_size = 14) +
    theme(
      plot.title = element_text(face = "bold", size = 18, hjust = 0.5),
      plot.subtitle = element_text(hjust = 0.5, color = "gray40", size = 13),
      legend.position = "right",
      legend.title = element_text(face = "bold", size = 13),
      legend.text = element_text(size = 11),
      panel.grid.minor = element_blank(),
      axis.text.x = element_text(angle = 45, hjust = 1)
    )
  
  ggsave(output_file, plot = p, width = 14, height = 9, dpi = 300)
  cat(sprintf("✓ Evolução temporal por clusters salva: %s\n", output_file))
}

################################################################################
# EXECUÇÃO PRINCIPAL
################################################################################
main <- function() {
  caminho_bib <- "../corpus.bib"
  
  if (!file.exists(caminho_bib)) {
    stop("❌ Error: .bib file not found at: ", caminho_bib)
  }
  
  # 1. Extrair dados
  dados <- extrair_dados_temporais(caminho_bib)
  
  # 2. Agregar por ano
  dados_temporais <- agregar_por_ano(dados)
  
  # 3. Calcular tendências
  tendencias <- calcular_tendencias(dados_temporais)
  
  # 4. Visualizações
  cat("📊 Generating visualizations...\n")
  plot_publicacoes_tempo(dados_temporais$publicacoes)
  plot_algoritmos_tempo(dados_temporais$algoritmos)
  plot_metodos_tempo(dados_temporais$metodos)
  plot_temas_tempo(dados_temporais$temas)
  plot_regioes_tempo(dados_temporais$regioes)
  plot_heatmap_evolucao(dados_temporais)
  plot_tendencias(tendencias)
  plot_clusters_tempo(dados_temporais)
  
  # 5. Relatório
  gerar_relatorio(dados_temporais, tendencias)
  
  # 6. Salvar dados
  salvar_dados(dados_temporais, tendencias)
  
  cat("\n")
  cat("================================================================================\n")
  cat("✅ TEMPORAL ANALYSIS COMPLETED SUCCESSFULLY!\n")
  cat("================================================================================\n")
}

tryCatch({
  main()
}, error = function(e) {
  cat("\n❌ ERROR during execution:\n")
  cat(conditionMessage(e), "\n")
})
