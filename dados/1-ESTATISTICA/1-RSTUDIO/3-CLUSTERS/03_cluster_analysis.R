################################################################################
# ANÁLISE DE CLUSTERS (K-MEANS E HIERÁRQUICO) - GGPLOT2
# Machine Learning em etnografia e conhecimentos tradicionais
#
# Este script realiza clustering usando factoextra/dendextend
# e gera visualizações elegantes com ggplot2
#
# Outputs:
#   - cluster_elbow_silhouette.png (Determinação do k ótimo)
#   - cluster_kmeans_scatter.png (Visualização dos clusters)
#   - cluster_dendrogram.png (Dendrograma hierárquico)
#   - cluster_heatmap_profiles.png (Perfil de características por cluster)
#   - cluster_relatorio.txt (Análise detalhada)
#   - cluster_resultados.csv (Dados com clusters)
################################################################################

rm(list = ls())
gc()

packages <- c("bib2df", "tidyverse", "factoextra", "cluster", "dendextend", 
              "viridis", "patchwork", "pheatmap", "NbClust")

for (pkg in packages) {
  if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
    install.packages(pkg, dependencies = TRUE, repos = "https://cloud.r-project.org")
    library(pkg, character.only = TRUE)
  }
}

cat("\n")
cat("================================================================================\n")
cat("ANÁLISE DE CLUSTERS (K-MEANS E HIERÁRQUICO) - GGPLOT2\n")
cat("Machine Learning em etnografia e conhecimentos tradicionais\n")
cat("================================================================================\n\n")

################################################################################
# FUNÇÃO: Extrair dados
################################################################################
extrair_dados_clustering <- function(caminho_bib) {
  cat("📚 Extraindo dados do arquivo .bib...\n")
  
  bib_data <- bib2df(caminho_bib)
  texto_completo <- tolower(paste(bib_data$TITLE, bib_data$ABSTRACT, bib_data$KEYWORDS, sep = " "))
  
  dados <- data.frame(
    ID = 1:nrow(bib_data),
    Titulo = bib_data$TITLE,
    Ano = as.numeric(bib_data$YEAR),
    
    # Algoritmos ML (padrões mais amplos)
    RandomForest = as.integer(grepl("random.?forest|\\brf\\b", texto_completo)),
    SVM = as.integer(grepl("support.?vector|\\bsvm\\b", texto_completo)),
    NeuralNetwork = as.integer(grepl("neural|deep.?learning|\\bcnn\\b|lstm|\\bann\\b|network", texto_completo)),
    MachineLearning = as.integer(grepl("machine.?learning|artificial.?intelligence|\\bai\\b|\\bml\\b|algorithm|classification|clustering|predictive", texto_completo)),
    DataMining = as.integer(grepl("data.?mining|text.?mining|knowledge.?discovery", texto_completo)),
    NLP = as.integer(grepl("natural.?language|\\bnlp\\b|text.?analysis|sentiment", texto_completo)),
    
    # Métodos Etnográficos (padrões mais amplos)
    Ethnography = as.integer(grepl("ethnograph|field.?work|qualitative", texto_completo)),
    Interview = as.integer(grepl("interview|semi.?structured|oral|survey|questionnaire", texto_completo)),
    Participatory = as.integer(grepl("participatory|community.?based|\\bcbpr\\b|action.?research", texto_completo)),
    Observation = as.integer(grepl("observation|field.?study", texto_completo)),
    CaseStudy = as.integer(grepl("case.?study|case.?studies", texto_completo)),
    
    # Conhecimentos Tradicionais (padrões mais amplos)
    TraditionalKnowledge = as.integer(grepl("traditional.?knowledge|indigenous.?knowledge|local.?knowledge|\\btek\\b", texto_completo)),
    Ethnobotany = as.integer(grepl("ethnobotany|ethnobotanical|medicinal.?plant|herbal|phytomedicine", texto_completo)),
    Indigenous = as.integer(grepl("indigenous|native|aboriginal|tribal|traditional.?communit", texto_completo)),
    CulturalKnowledge = as.integer(grepl("cultural.?heritage|intangible|ancestral|folk.?knowledge", texto_completo)),
    TraditionalPractices = as.integer(grepl("traditional.?practice|traditional.?use|traditional.?medicine", texto_completo)),
    
    # Agroecologia (padrões mais amplos)
    Agroecology = as.integer(grepl("agroecology|agroecological|sustainable.?agriculture|organic", texto_completo)),
    Biodiversity = as.integer(grepl("biodiversity|biological.?diversity|species.?diversity", texto_completo)),
    Conservation = as.integer(grepl("conservation|preserve|sustainability|sustainable", texto_completo)),
    FoodSecurity = as.integer(grepl("food.?security|nutrition|food.?system", texto_completo)),
    ClimateChange = as.integer(grepl("climate.?change|adaptation|resilience", texto_completo)),
    
    # Aplicações
    Documentation = as.integer(grepl("documentation|mapping|preservation|database", texto_completo)),
    SpatialAnalysis = as.integer(grepl("spatial|\\bgis\\b|geographic|remote.?sensing|map", texto_completo)),
    Assessment = as.integer(grepl("assessment|evaluation|analysis|study", texto_completo)),
    Management = as.integer(grepl("management|conservation|planning", texto_completo)),
    
    # Contexto geográfico
    Developing = as.integer(grepl("developing|rural|remote|village", texto_completo)),
    Africa = as.integer(grepl("africa|ethiopia|kenya|tanzania|uganda", texto_completo)),
    Asia = as.integer(grepl("asia|india|china|indonesia|nepal|thailand", texto_completo)),
    LatinAmerica = as.integer(grepl("latin.?america|brazil|mexico|peru|colombia|amazon", texto_completo)),
    
    stringsAsFactors = FALSE
  )
  
  # DIAGNÓSTICO: Mostrar quantas features têm variação
  cat("\n📊 DIAGNÓSTICO DE FEATURES:\n")
  feature_vars <- sapply(dados[, -(1:3)], var, na.rm = TRUE)
  n_features_com_variacao <- sum(feature_vars > 0, na.rm = TRUE)
  cat(sprintf("  Features com variação: %d/%d\n", n_features_com_variacao, length(feature_vars)))
  cat(sprintf("  Features sem variação: %d\n", sum(feature_vars == 0, na.rm = TRUE)))
  
  # Mostrar top features
  cat("\n  Top 10 features com mais variação:\n")
  top_features <- sort(feature_vars, decreasing = TRUE)[1:10]
  for (i in seq_along(top_features)) {
    soma <- sum(dados[[names(top_features)[i]]], na.rm = TRUE)
    cat(sprintf("    %d. %s: %d estudos (%.1f%%)\n", i, names(top_features)[i], 
                soma, 100*soma/nrow(dados)))
  }
  cat("\n")
  
  cat(sprintf("✓ Total de estudos extraídos: %d\n\n", nrow(dados)))
  return(dados)
}

################################################################################
# FUNÇÃO: Determinar k ótimo
################################################################################
determinar_k_otimo <- function(features_scaled, k_max = 10) {
  cat("🔬 Determinando número ótimo de clusters...\n")
  
  # Guardar índices originais antes da limpeza
  n_original <- nrow(features_scaled)
  indices_originais <- 1:n_original
  
  # Remover NA e Inf
  indices_completos <- complete.cases(features_scaled)
  features_scaled <- features_scaled[indices_completos, ]
  indices_originais <- indices_originais[indices_completos]
  
  features_scaled[is.infinite(features_scaled)] <- 0
  
  # Remover duplicatas para evitar erro de pontos idênticos
  indices_unicos <- !duplicated(features_scaled)
  features_scaled <- features_scaled[indices_unicos, ]
  indices_validos <- indices_originais[indices_unicos]
  
  # Salvar índices como atributo
  attr(features_scaled, "indices_validos") <- indices_validos
  
  # Ajustar k_max baseado no número de observações únicas
  n_unique <- nrow(features_scaled)
  k_max <- min(k_max, floor(n_unique / 2))
  
  cat(sprintf("  Observações únicas: %d/%d | k_max ajustado: %d\n", n_unique, n_original, k_max))
  
  if (k_max < 2) {
    cat("⚠️  Dados insuficientes para clustering. Retornando k=2.\n")
    return(list(k_otimo = 2, features_scaled = features_scaled))
  }
  
  # Método Elbow
  wss <- sapply(1:k_max, function(k) {
    kmeans(features_scaled, centers = k, nstart = 25)$tot.withinss
  })
  
  # Silhouette
  sil_width <- sapply(2:k_max, function(k) {
    km <- kmeans(features_scaled, centers = k, nstart = 25)
    ss <- silhouette(km$cluster, dist(features_scaled))
    mean(ss[, 3])
  })
  
  # Plots
  p1 <- ggplot(data.frame(k = 1:k_max, WSS = wss), aes(x = k, y = WSS)) +
    geom_line(color = "#2E86AB", size = 1.2) +
    geom_point(color = "#2E86AB", size = 3) +
    labs(title = "Elbow Method", x = "Number of Clusters (k)", y = "Within-Cluster Sum of Squares") +
    theme_minimal(base_size = 12) +
    theme(plot.title = element_text(face = "bold", hjust = 0.5))
  
  p2 <- ggplot(data.frame(k = 2:k_max, Silhouette = sil_width), aes(x = k, y = Silhouette)) +
    geom_line(color = "#A23B72", size = 1.2) +
    geom_point(color = "#A23B72", size = 3) +
    labs(title = "Silhouette Score", x = "Number of Clusters (k)", y = "Average Silhouette Width") +
    theme_minimal(base_size = 12) +
    theme(plot.title = element_text(face = "bold", hjust = 0.5))
  
  combined <- p1 | p2
  ggsave("cluster_elbow_silhouette.png", plot = combined, width = 12, height = 5, dpi = 300)
  
  k_otimo <- which.max(sil_width) + 1
  cat(sprintf("✓ k ótimo sugerido: %d (Silhouette = %.3f)\n\n", k_otimo, max(sil_width)))
  
  return(list(k_otimo = k_otimo, features_scaled = features_scaled))
}

################################################################################
# FUNÇÃO: K-Means Clustering
################################################################################
executar_kmeans <- function(features_scaled, k) {
  cat(sprintf("🔬 Executando K-Means com k=%d...\n", k))
  
  set.seed(42)
  kmeans_result <- kmeans(features_scaled, centers = k, nstart = 50, iter.max = 100)
  
  cat(sprintf("✓ K-Means concluído: %d clusters\n", k))
  cat(sprintf("  Between SS / Total SS: %.2f%%\n\n", 
              100 * kmeans_result$betweenss / kmeans_result$totss))
  
  return(kmeans_result)
}

################################################################################
# FUNÇÃO: Visualizar K-Means
################################################################################
plot_kmeans <- function(features_scaled, kmeans_result, dados, output_file = "cluster_kmeans_scatter.png") {
  cat("📊 Gerando visualização K-Means...\n")
  
  # PCA para redução dimensional
  pca <- prcomp(features_scaled)
  pca_data <- data.frame(
    PC1 = pca$x[, 1],
    PC2 = pca$x[, 2],
    Cluster = as.factor(kmeans_result$cluster)
  )
  
  # Definir labels descritivos para os 5 clusters
  cluster_labels <- c(
    "1" = "Grupo 1",
    "2" = "Grupo 2", 
    "3" = "Grupo 3",
    "4" = "Grupo 4",
    "5" = "Grupo 5"
  )
  
  pca_data$Cluster_Label <- cluster_labels[as.character(pca_data$Cluster)]
  
  # Cores distintas e visíveis para 5 clusters
  cores_clusters <- c("#E41A1C", "#377EB8", "#4DAF4A", "#FF7F00", "#984EA3")  # vermelho, azul, verde, laranja, roxo
  
  p <- ggplot(pca_data, aes(x = PC1, y = PC2, color = Cluster_Label, fill = Cluster_Label)) +
    geom_point(size = 3.5, alpha = 0.7, shape = 16) +
    stat_ellipse(geom = "polygon", alpha = 0.2, level = 0.95, linewidth = 1.2) +
    scale_color_manual(values = cores_clusters, name = "Grupos") +
    scale_fill_manual(values = cores_clusters, name = "Grupos") +
    labs(
      title = "Agrupamento de Estudos por Características",
      subtitle = sprintf("%d grupos principais identificados via K-Means", length(unique(kmeans_result$cluster))),
      x = sprintf("Componente Principal 1 (%.1f%% da variância)", 100 * summary(pca)$importance[2, 1]),
      y = sprintf("Componente Principal 2 (%.1f%% da variância)", 100 * summary(pca)$importance[2, 2])
    ) +
    theme_minimal(base_size = 15) +
    theme(
      plot.title = element_text(face = "bold", size = 18, hjust = 0.5),
      plot.subtitle = element_text(hjust = 0.5, color = "gray40", size = 13),
      legend.position = "right",
      legend.title = element_text(face = "bold", size = 14),
      legend.text = element_text(size = 12),
      legend.key.size = unit(1.5, "lines"),
      panel.grid.minor = element_blank(),
      panel.grid.major = element_line(color = "gray90"),
      panel.background = element_rect(fill = "white"),
      plot.margin = margin(20, 20, 20, 20)
    )
  
  ggsave(output_file, plot = p, width = 14, height = 10, dpi = 300)
  cat(sprintf("✓ Visualização K-Means salva: %s\n", output_file))
}

################################################################################
# FUNÇÃO: Clustering Hierárquico
################################################################################
executar_clustering_hierarquico <- function(features_scaled, k) {
  cat("🔬 Executando Clustering Hierárquico...\n")
  
  # Calcular matriz de distâncias
  dist_matrix <- dist(features_scaled, method = "euclidean")
  
  # Clustering hierárquico (Ward)
  hc <- hclust(dist_matrix, method = "ward.D2")
  
  # Cortar dendrograma
  clusters <- cutree(hc, k = k)
  
  cat(sprintf("✓ Clustering Hierárquico concluído: %d clusters\n\n", k))
  
  return(list(hc = hc, clusters = clusters))
}

################################################################################
# FUNÇÃO: Plot Dendrograma
################################################################################
plot_dendrogram <- function(hc_result, k, output_file = "cluster_dendrogram.png") {
  cat("📊 Gerando dendrograma...\n")
  
  # Cores distintas para 5 clusters
  cores_dend <- c("#E41A1C", "#377EB8", "#4DAF4A", "#FF7F00", "#984EA3")
  
  # Converter para dendextend
  dend <- as.dendrogram(hc_result$hc)
  dend <- color_branches(dend, k = k, col = cores_dend)
  dend <- color_labels(dend, k = k, col = cores_dend)
  
  png(output_file, width = 4200, height = 2800, res = 300)
  par(mar = c(6, 5, 5, 2), cex.main = 1.8, cex.lab = 1.4, cex.axis = 1.2)
  plot(dend, 
       main = "Dendrograma Hierárquico - 5 Grupos Principais",
       ylab = "Distância Euclidiana (Método Ward)",
       xlab = "",
       horiz = FALSE)
  
  # Adicionar retângulos ao redor dos clusters
  rect.dendrogram(dend, k = k, border = cores_dend, lwd = 2.5)
  dev.off()
  
  cat(sprintf("✓ Dendrograma salvo: %s\n", output_file))
}

################################################################################
# FUNÇÃO: Heatmap de Perfis de Clusters
################################################################################
plot_heatmap_profiles <- function(dados, kmeans_result, output_file = "cluster_heatmap_profiles.png") {
  cat("📊 Gerando heatmap de perfis de clusters (features principais)...\n")
  
  # Adicionar cluster aos dados
  dados_cluster <- dados %>%
    mutate(Cluster = as.factor(kmeans_result$cluster))
  
  # Calcular médias por cluster
  features_cols <- setdiff(names(dados), c("ID", "Titulo", "Ano"))
  
  cluster_profiles <- dados_cluster %>%
    group_by(Cluster) %>%
    summarise(across(all_of(features_cols), \(x) mean(x, na.rm = TRUE))) %>%
    column_to_rownames("Cluster")
  
  # SELECIONAR APENAS TOP 15 FEATURES MAIS DISCRIMINATIVAS
  # Calcular variância entre clusters para cada feature
  feature_variance <- apply(cluster_profiles, 2, var)
  top_features <- names(sort(feature_variance, decreasing = TRUE)[1:15])
  
  cat(sprintf("  Selecionadas %d features mais discriminativas\n", length(top_features)))
  cat("  Top features:", paste(head(top_features, 5), collapse = ", "), "...\n")
  
  # Filtrar apenas top features
  cluster_profiles_filtered <- cluster_profiles[, top_features]
  
  # Transpor para ter features como linhas e clusters como colunas
  cluster_profiles_t <- t(cluster_profiles_filtered)
  
  # Renomear colunas (clusters) com nomes descritivos
  cluster_names <- c(
    "Min. de\nDT e CT",
    "ML em\nCons.",
    "ML e Povos\nInd.",
    "Etnobotânica\nApl.",
    "ML e Mud.\nClim."
  )
  colnames(cluster_profiles_t) <- cluster_names[1:ncol(cluster_profiles_t)]
  
  # Gerar heatmap no estilo do PCA
  png(output_file, width = 3000, height = 2400, res = 300)
  
  # Cores iguais ao PCA loadings
  cores_heatmap <- colorRampPalette(c("#2166AC", "#4393C3", "#F7F7F7", "#D6604D", "#B2182B"))(100)
  
  pheatmap(
    cluster_profiles_t,
    color = cores_heatmap,
    cluster_rows = TRUE,   # Clusterizar features
    cluster_cols = FALSE,  # NÃO clusterizar grupos (já definidos)
    fontsize = 13,
    fontsize_row = 11,     # Features
    fontsize_col = 14,     # Nomes dos grupos (maior)
    main = "Perfil de Características por Grupo",
    angle_col = 0,         # Grupos na horizontal
    border_color = "grey80",
    cellwidth = 50,
    cellheight = 18,
    legend = TRUE,
    legend_breaks = seq(0, 1, 0.25),
    legend_labels = c("0.00", "0.25", "0.50", "0.75", "1.00"),
    show_rownames = TRUE,
    show_colnames = TRUE,
    display_numbers = FALSE,  # SEM números dentro
    treeheight_row = 30,      # Dendrograma nas features
    treeheight_col = 0        # SEM dendrograma nos grupos
  )
  
  dev.off()
  
  cat(sprintf("✓ Heatmap de perfis salvo: %s\n", output_file))
}

################################################################################
# FUNÇÃO: Relatório
################################################################################
gerar_relatorio <- function(dados, kmeans_result, hc_result, output_file = "cluster_relatorio.txt") {
  cat("\n📝 Gerando relatório estatístico...\n")
  
  dados_cluster <- dados %>%
    mutate(Cluster_KMeans = as.factor(kmeans_result$cluster),
           Cluster_HC = as.factor(hc_result$clusters))
  
  sink(output_file)
  cat("================================================================================\n")
  cat("RELATÓRIO DE ANÁLISE DE CLUSTERS - ML PARA INDICAÇÕES GEOGRÁFICAS\n")
  cat("================================================================================\n\n")
  cat(sprintf("Data de execução: %s\n", Sys.time()))
  cat(sprintf("Total de observações: %d\n", nrow(dados)))
  cat(sprintf("Número de clusters: %d\n\n", length(unique(kmeans_result$cluster))))
  
  cat("--------------------------------------------------------------------------------\n")
  cat("K-MEANS CLUSTERING - ESTATÍSTICAS\n")
  cat("--------------------------------------------------------------------------------\n")
  cat(sprintf("Between SS / Total SS: %.2f%%\n", 
              100 * kmeans_result$betweenss / kmeans_result$totss))
  cat(sprintf("Total Within SS: %.2f\n\n", kmeans_result$tot.withinss))
  
  cat("Tamanho dos clusters (K-Means):\n")
  print(table(kmeans_result$cluster))
  cat("\n")
  
  cat("--------------------------------------------------------------------------------\n")
  cat("CLUSTERING HIERÁRQUICO - ESTATÍSTICAS\n")
  cat("--------------------------------------------------------------------------------\n")
  cat("Tamanho dos clusters (Hierárquico):\n")
  print(table(hc_result$clusters))
  cat("\n")
  
  cat("--------------------------------------------------------------------------------\n")
  cat("PERFIL DOS CLUSTERS (K-Means) - Características Dominantes\n")
  cat("--------------------------------------------------------------------------------\n")
  
  features_cols <- setdiff(names(dados), c("ID", "Titulo", "Ano"))
  
  for (k in sort(unique(kmeans_result$cluster))) {
    cat(sprintf("\n=== CLUSTER %d (n=%d) ===\n", k, sum(kmeans_result$cluster == k)))
    
    cluster_data <- dados_cluster %>%
      filter(Cluster_KMeans == k) %>%
      select(all_of(features_cols)) %>%
      summarise(across(everything(), mean, na.rm = TRUE)) %>%
      pivot_longer(everything(), names_to = "Feature", values_to = "Media") %>%
      arrange(desc(Media))
    
    cat("\nTop 10 características mais frequentes:\n")
    print(head(cluster_data, 10))
  }
  
  cat("\n================================================================================\n")
  sink()
  
  cat(sprintf("✓ Relatório estatístico salvo: %s\n", output_file))
}

################################################################################
# FUNÇÃO: Salvar dados
################################################################################
salvar_dados <- function(dados, kmeans_result, hc_result) {
  dados_resultado <- dados %>%
    mutate(
      Cluster_KMeans = kmeans_result$cluster,
      Cluster_Hierarquico = hc_result$clusters
    )
  
  write.csv(dados_resultado, "cluster_resultados.csv", row.names = FALSE)
  cat("\n✓ Dados salvos: cluster_resultados.csv\n")
}

################################################################################
# EXECUÇÃO PRINCIPAL
################################################################################
main <- function() {
  caminho_bib <- "../corpus.bib"
  
  if (!file.exists(caminho_bib)) {
    stop("❌ Erro: Arquivo .bib não encontrado em: ", caminho_bib)
  }
  
  # 1. Extrair dados
  dados <- extrair_dados_clustering(caminho_bib)
  
  # 2. Preparar features
  features <- dados %>% select(-ID, -Titulo, -Ano)
  features_scaled <- scale(features)
  
  # 3. Determinar k ótimo (fixado em 5 alinhado com PCA)
  result <- determinar_k_otimo(features_scaled, k_max = 10)
  k_otimo <- 5  # Fixado em 5 clusters (alinhado com 5 componentes do PCA)
  features_scaled <- result$features_scaled
  
  cat(sprintf("📊 Usando k=%d clusters (alinhado com análise PCA)\n\n", k_otimo))
  
  # Filtrar dados originais para corresponder aos dados limpos
  # (remover mesmas linhas que foram removidas em determinar_k_otimo)
  indices_validos <- attr(features_scaled, "indices_validos")
  if (!is.null(indices_validos)) {
    dados <- dados[indices_validos, ]
  } else {
    # Se não houver atributo, filtrar por observações completas
    indices_completos <- complete.cases(features)
    dados <- dados[indices_completos, ]
    # Remover duplicatas
    dados <- dados[!duplicated(features[indices_completos, ]), ]
  }
  
  cat(sprintf("📊 Dados após limpeza: %d estudos\n\n", nrow(dados)))
  
  # 4. K-Means
  kmeans_result <- executar_kmeans(features_scaled, k = k_otimo)
  
  # 5. Clustering Hierárquico
  hc_result <- executar_clustering_hierarquico(features_scaled, k = k_otimo)
  
  # 6. Visualizações
  cat("📊 Gerando visualizações...\n")
  plot_kmeans(features_scaled, kmeans_result, dados)
  plot_dendrogram(hc_result, k = k_otimo)
  plot_heatmap_profiles(dados, kmeans_result)
  
  # 7. Relatório
  gerar_relatorio(dados, kmeans_result, hc_result)
  
  # 8. Salvar dados
  salvar_dados(dados, kmeans_result, hc_result)
  
  cat("\n")
  cat("================================================================================\n")
  cat("✅ ANÁLISE DE CLUSTERS CONCLUÍDA COM SUCESSO!\n")
  cat("================================================================================\n")
}

tryCatch({
  main()
}, error = function(e) {
  cat("\n❌ ERRO durante a execução:\n")
  cat(conditionMessage(e), "\n")
})
