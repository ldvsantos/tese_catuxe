################################################################################
# NETWORK ANALYSIS (CO-OCCURRENCE NETWORKS) - GGPLOT2
# Machine Learning em Etnografia e Conhecimentos Tradicionais
#
# Este script realiza análise de redes de co-ocorrência usando igraph/ggraph
# e gera visualizações com ggplot2
#
# Outputs:
#   - network_completa.png (Rede completa de co-ocorrências)
#   - network_ml_metodos.png (ML × Métodos Etnográficos)
#   - network_ml_temas.png (ML × Temas de CT)
#   - network_centrality_metrics.png (Métricas de centralidade)
#   - network_communities.png (Detecção de comunidades)
#   - network_clusters.png (Rede colorida por grupos temáticos)
#   - network_relatorio.txt (Métricas da rede)
#   - network_*.graphml (Arquivos para Gephi)
################################################################################

rm(list = ls())
gc()

packages <- c("bib2df", "tidyverse", "igraph", "ggraph", "tidygraph", 
              "viridis", "patchwork", "scales")

for (pkg in packages) {
  if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
    install.packages(pkg, dependencies = TRUE, repos = "https://cloud.r-project.org")
    library(pkg, character.only = TRUE)
  }
}

cat("\n")
cat("================================================================================\n")
cat("ANÁLISE DE REDES (CO-OCORRÊNCIAS) - GGRAPH + GGPLOT2\n")
cat("Machine Learning em Etnografia e Conhecimentos Tradicionais\n")
cat("================================================================================\n\n")

################################################################################
# FUNÇÃO: Extrair co-ocorrências
################################################################################
extrair_coocorrencias <- function(caminho_bib) {
  cat("📚 Extraindo co-ocorrências do arquivo .bib...\n")
  
  bib_data <- bib2df(caminho_bib)
  texto_completo <- tolower(paste(bib_data$TITLE, bib_data$ABSTRACT, bib_data$KEYWORDS, sep = " "))
  
  # Definir categorias
  algoritmos <- c("RandomForest", "SVM", "NeuralNetwork", "KNN", "DecisionTree", "NLP")
  metodos_etnograficos <- c("Ethnography", "Interview", "Participatory", "Observation", "FocusGroup")
  conhecimentos <- c("TraditionalKnowledge", "Ethnobotany", "IndigenousPeoples", "LocalKnowledge")
  agroecologia <- c("Agroecology", "Biodiversity", "Conservation", "TraditionalFarming")
  regioes <- c("LatinAmerica", "Africa", "Asia", "Europe")
  
  # Detectar presença
  presenca <- data.frame(
    # Algoritmos ML
    RandomForest = grepl("random forest", texto_completo),
    SVM = grepl("svm|support vector", texto_completo),
    NeuralNetwork = grepl("neural|deep learning|cnn|lstm", texto_completo),
    KNN = grepl("k-nearest|knn", texto_completo),
    DecisionTree = grepl("decision tree", texto_completo),
    NLP = grepl("natural language processing|nlp\\b|text mining", texto_completo),
    
    # Métodos Etnográficos
    Ethnography = grepl("ethnography|ethnographic", texto_completo),
    Interview = grepl("interview|semi-structured|oral history", texto_completo),
    Participatory = grepl("participatory|community-based", texto_completo),
    Observation = grepl("participant observation|field work", texto_completo),
    FocusGroup = grepl("focus group|group discussion", texto_completo),
    
    # Conhecimentos Tradicionais
    TraditionalKnowledge = grepl("traditional knowledge|indigenous knowledge", texto_completo),
    Ethnobotany = grepl("ethnobotany|ethnobotanical|medicinal plants", texto_completo),
    IndigenousPeoples = grepl("indigenous|native people|aboriginal", texto_completo),
    LocalKnowledge = grepl("local knowledge|community knowledge", texto_completo),
    
    # Agroecologia
    Agroecology = grepl("agroecology|agroecological", texto_completo),
    Biodiversity = grepl("biodiversity|agrobiodiversity", texto_completo),
    Conservation = grepl("conservation|sustainability", texto_completo),
    TraditionalFarming = grepl("traditional farming|traditional agriculture", texto_completo),
    
    # Regiões
    LatinAmerica = grepl("latin america|brazil|mexico|peru|colombia|amazon", texto_completo),
    Africa = grepl("africa|african|kenya|ethiopia", texto_completo),
    Asia = grepl("asia|india|china|indonesia|thailand", texto_completo),
    Europe = grepl("europe|european", texto_completo)
  )
  
  cat(sprintf("✓ Total de estudos analisados: %d\n\n", nrow(presenca)))
  
  return(list(presenca = presenca, 
              algoritmos = algoritmos, 
              metodos_etnograficos = metodos_etnograficos, 
              conhecimentos = conhecimentos,
              agroecologia = agroecologia,
              regioes = regioes))
}

################################################################################
# FUNÇÃO: Construir rede de co-ocorrências
################################################################################
construir_rede <- function(presenca_data, min_coocorrencia = 3) {
  cat(sprintf("🔬 Construindo rede de co-ocorrências (mínimo: %d)...\n", min_coocorrencia))
  
  # Calcular matriz de co-ocorrências
  cooc_matrix <- t(as.matrix(presenca_data)) %*% as.matrix(presenca_data)
  
  # Remover diagonal (auto-conexões)
  diag(cooc_matrix) <- 0
  
  # Filtrar por mínimo de co-ocorrências
  cooc_matrix[cooc_matrix < min_coocorrencia] <- 0
  
  # Criar grafo
  g <- graph_from_adjacency_matrix(cooc_matrix, mode = "undirected", 
                                    weighted = TRUE, diag = FALSE)
  
  # Remover nós isolados
  g <- delete.vertices(g, degree(g) == 0)
  
  cat(sprintf("✓ Rede construída: %d nós, %d arestas\n\n", vcount(g), ecount(g)))
  
  return(g)
}

################################################################################
# FUNÇÃO: Calcular métricas de rede
################################################################################
calcular_metricas_rede <- function(g) {
  cat("📊 Calculando métricas de rede...\n")
  
  metricas <- data.frame(
    Node = V(g)$name,
    Degree = degree(g),
    Betweenness = betweenness(g, normalized = TRUE),
    Closeness = closeness(g, normalized = TRUE),
    Eigenvector = eigen_centrality(g)$vector,
    stringsAsFactors = FALSE
  )
  
  metricas <- metricas %>% arrange(desc(Degree))
  
  cat("✓ Métricas calculadas\n\n")
  
  return(metricas)
}

################################################################################
# FUNÇÃO: Detectar comunidades
################################################################################
detectar_comunidades <- function(g) {
  cat("🔬 Detectando comunidades (Louvain)...\n")
  
  communities <- cluster_louvain(g)
  V(g)$community <- membership(communities)
  
  cat(sprintf("✓ Comunidades detectadas: %d\n", length(unique(V(g)$community))))
  cat(sprintf("  Modularidade: %.3f\n\n", modularity(communities)))
  
  return(g)
}

################################################################################
# FUNÇÃO: Plot da rede completa
################################################################################
plot_network_completa <- function(g, output_file = "network_completa.png") {
  cat("📊 Gerando visualização da rede completa...\n")
  
  # Converter para tidygraph
  tg <- as_tbl_graph(g)
  
  p <- ggraph(tg, layout = "fr") +
    geom_edge_link(aes(width = weight, alpha = weight), color = "gray50") +
    geom_node_point(aes(size = degree(g), color = as.factor(V(g)$community)), alpha = 0.8) +
    geom_node_text(aes(label = name), repel = TRUE, size = 3.5, fontface = "bold") +
    scale_edge_width(range = c(0.5, 3)) +
    scale_edge_alpha(range = c(0.3, 0.8)) +
    scale_size_continuous(range = c(3, 12)) +
    scale_color_viridis_d(option = "plasma", begin = 0.1, end = 0.9) +
    labs(
      title = "Rede de Co-ocorrências - ML em Etnografia e Conhecimentos Tradicionais",
      subtitle = sprintf("%d nós, %d arestas | Comunidades detectadas: %d", 
                         vcount(g), ecount(g), length(unique(V(g)$community))),
      color = "Comunidade",
      size = "Grau"
    ) +
    theme_graph(base_family = "sans") +
    theme(
      plot.title = element_text(face = "bold", size = 16, hjust = 0.5),
      plot.subtitle = element_text(hjust = 0.5, color = "gray40", size = 12),
      legend.position = "right"
    )
  
  ggsave(output_file, plot = p, width = 16, height = 12, dpi = 300)
  cat(sprintf("✓ Rede completa salva: %s\n", output_file))
}

################################################################################
# FUNÇÃO: Plot de rede específica (Algoritmo × Produto)
################################################################################
plot_network_especifica <- function(presenca_data, categorias1, categorias2, 
                                     titulo, output_file, min_cooc = 2) {
  cat(sprintf("📊 Gerando rede: %s...\n", titulo))
  
  # Selecionar apenas categorias relevantes (remover espaços do nome GC-MS)
  categorias1 <- gsub("-", "", categorias1)
  categorias2 <- gsub("-", "", categorias2)
  
  # Verificar quais colunas existem
  cols <- c(categorias1, categorias2)
  cols_existentes <- cols[cols %in% colnames(presenca_data)]
  
  if (length(cols_existentes) < 2) {
    cat(sprintf("⚠️  Pulando %s - colunas insuficientes\n", output_file))
    return(invisible(NULL))
  }
  
  presenca_sub <- presenca_data[, cols_existentes]
  
  # Construir rede
  cooc_matrix <- t(as.matrix(presenca_sub)) %*% as.matrix(presenca_sub)
  diag(cooc_matrix) <- 0
  cooc_matrix[cooc_matrix < min_cooc] <- 0
  
  g_sub <- graph_from_adjacency_matrix(cooc_matrix, mode = "undirected", 
                                       weighted = TRUE, diag = FALSE)
  g_sub <- delete.vertices(g_sub, degree(g_sub) == 0)
  
  # Adicionar atributos de tipo
  V(g_sub)$type <- ifelse(V(g_sub)$name %in% categorias1, "Tipo1", "Tipo2")
  
  # Plot
  tg <- as_tbl_graph(g_sub)
  
  p <- ggraph(tg, layout = "kk") +
    geom_edge_link(aes(width = weight, alpha = weight), color = "gray40") +
    geom_node_point(aes(size = degree(g_sub), color = V(g_sub)$type), alpha = 0.8) +
    geom_node_text(aes(label = name), repel = TRUE, size = 4, fontface = "bold") +
    scale_edge_width(range = c(0.5, 4)) +
    scale_edge_alpha(range = c(0.3, 0.9)) +
    scale_size_continuous(range = c(4, 15)) +
    scale_color_manual(values = c("Tipo1" = "#2E86AB", "Tipo2" = "#FC4E07")) +
    labs(
      title = titulo,
      subtitle = sprintf("%d nós, %d arestas", vcount(g_sub), ecount(g_sub)),
      color = "Categoria",
      size = "Grau"
    ) +
    theme_graph(base_family = "sans") +
    theme(
      plot.title = element_text(face = "bold", size = 14, hjust = 0.5),
      plot.subtitle = element_text(hjust = 0.5, color = "gray40"),
      legend.position = "right"
    )
  
  ggsave(output_file, plot = p, width = 12, height = 9, dpi = 300)
  cat(sprintf("✓ Rede salva: %s\n", output_file))
}

################################################################################
# FUNÇÃO: Plot de rede tripartida (ML × Métodos × CT)
################################################################################
plot_network_tripartida <- function(presenca_data, algoritmos, metodos, conhecimentos, 
                                     output_file = "network_ml_metodos_ct.png") {
  cat("📊 Gerando rede tripartida ML × Métodos Etnográficos × CT...\n")
  
  # Selecionar apenas as colunas relevantes
  vars_ml <- c("RandomForest", "SVM", "NeuralNetwork", "KNN", "DecisionTree", "NLP")
  vars_metodos <- c("Ethnography", "Interview", "Participatory", "Observation", "FocusGroup")
  vars_ct <- c("TraditionalKnowledge", "Ethnobotany", "IndigenousPeoples", "LocalKnowledge")
  
  vars_selecionadas <- c(vars_ml, vars_metodos, vars_ct)
  presenca_subset <- presenca_data[, vars_selecionadas]
  
  # Calcular co-ocorrências
  cooc_matrix <- t(as.matrix(presenca_subset)) %*% as.matrix(presenca_subset)
  diag(cooc_matrix) <- 0
  cooc_matrix[cooc_matrix < 3] <- 0  # Filtrar co-ocorrências mínimas
  
  # Criar grafo
  g <- graph_from_adjacency_matrix(cooc_matrix, mode = "undirected", weighted = TRUE, diag = FALSE)
  g <- delete.vertices(g, degree(g) == 0)
  
  # Atribuir tipos aos nós
  node_types <- data.frame(
    name = V(g)$name,
    tipo = case_when(
      V(g)$name %in% vars_ml ~ "Algoritmos ML",
      V(g)$name %in% vars_metodos ~ "Métodos Etnográficos",
      V(g)$name %in% vars_ct ~ "Conhecimentos Tradicionais",
      TRUE ~ "Outro"
    )
  )
  
  V(g)$tipo <- node_types$tipo[match(V(g)$name, node_types$name)]
  V(g)$degree <- degree(g)
  
  # Cores por tipo
  cores_tipos <- c(
    "Algoritmos ML" = "#377EB8",              # Azul
    "Métodos Etnográficos" = "#4DAF4A",       # Verde
    "Conhecimentos Tradicionais" = "#FF7F00"  # Laranja
  )
  
  # Formas por tipo
  formas_tipos <- c(
    "Algoritmos ML" = 21,              # Círculo preenchido
    "Métodos Etnográficos" = 22,       # Quadrado preenchido
    "Conhecimentos Tradicionais" = 24  # Triângulo preenchido
  )
  
  # Converter para tidygraph
  g_tidy <- as_tbl_graph(g) %>%
    activate(nodes) %>%
    mutate(
      label = name,
      tipo = V(g)$tipo,
      degree = V(g)$degree
    )
  
  # Criar visualização
  p <- ggraph(g_tidy, layout = "fr") +
    geom_edge_link(aes(edge_width = weight, edge_alpha = weight), 
                   color = "gray60", show.legend = FALSE) +
    geom_node_point(aes(color = tipo, shape = tipo, size = degree), alpha = 0.9) +
    geom_node_text(aes(label = label), size = 3, repel = TRUE, 
                   max.overlaps = 20, bg.color = "white", bg.r = 0.1) +
    scale_color_manual(values = cores_tipos, name = "Tipo de Variável") +
    scale_shape_manual(values = formas_tipos, name = "Tipo de Variável") +
    scale_size_continuous(range = c(4, 12), name = "Grau (Degree)") +
    scale_edge_width(range = c(0.3, 2)) +
    scale_edge_alpha(range = c(0.3, 0.8)) +
    labs(
      title = "Co-ocorrências: Métodos ML × Métodos Etnográficos × Conhecimentos Tradicionais",
      subtitle = sprintf("Nós: %d | Arestas: %d | Threshold: 3+ co-ocorrências", 
                        vcount(g), ecount(g))
    ) +
    theme_graph(base_family = "sans") +
    theme(
      plot.title = element_text(face = "bold", size = 14, hjust = 0.5),
      plot.subtitle = element_text(hjust = 0.5, color = "gray40"),
      legend.position = "right"
    )
  
  ggsave(output_file, plot = p, width = 16, height = 12, dpi = 300)
  cat(sprintf("✓ Rede tripartida salva: %s\n", output_file))
}

################################################################################
# FUNÇÃO: Plot de métricas de centralidade
################################################################################
plot_centrality_metrics <- function(metricas, output_file = "network_centrality_metrics.png") {
  cat("📊 Gerando visualização de métricas de centralidade...\n")
  
  # Top 15 nós por grau
  top_nodes <- head(metricas, 15)
  
  # Preparar dados
  metricas_long <- top_nodes %>%
    select(Node, Degree, Betweenness, Closeness, Eigenvector) %>%
    pivot_longer(-Node, names_to = "Metric", values_to = "Value")
  
  p <- ggplot(metricas_long, aes(x = reorder(Node, Value), y = Value, fill = Metric)) +
    geom_col(alpha = 0.8) +
    coord_flip() +
    facet_wrap(~Metric, scales = "free_x") +
    scale_fill_viridis_d(option = "plasma") +
    labs(
      title = "Métricas de Centralidade - Top 15 Nós",
      subtitle = "Degree | Betweenness | Closeness | Eigenvector",
      x = "Nó",
      y = "Valor"
    ) +
    theme_minimal(base_size = 12) +
    theme(
      plot.title = element_text(face = "bold", size = 14, hjust = 0.5),
      plot.subtitle = element_text(hjust = 0.5, color = "gray40"),
      legend.position = "none",
      strip.text = element_text(face = "bold", size = 12)
    )
  
  ggsave(output_file, plot = p, width = 14, height = 10, dpi = 300)
  cat(sprintf("✓ Métricas de centralidade salvas: %s\n", output_file))
}

################################################################################
# FUNÇÃO: Plot de comunidades
################################################################################
plot_communities <- function(g, output_file = "network_communities.png") {
  cat("📊 Gerando visualização de comunidades...\n")
  
  tg <- as_tbl_graph(g)
  
  p <- ggraph(tg, layout = "fr") +
    geom_edge_link(aes(alpha = weight), color = "gray60", width = 0.5) +
    geom_node_point(aes(size = degree(g), color = as.factor(V(g)$community)), alpha = 0.9) +
    geom_node_text(aes(label = name, color = as.factor(V(g)$community)), 
                   repel = TRUE, size = 3, fontface = "bold", show.legend = FALSE) +
    scale_size_continuous(range = c(4, 14)) +
    scale_color_viridis_d(option = "turbo", begin = 0.1, end = 0.9) +
    labs(
      title = "Community Detection: Louvain Algorithm",
      subtitle = sprintf("%d communities identified in co-occurrence network", length(unique(V(g)$community))),
      color = "Community",
      size = "Degree Centrality"
    ) +
    theme_graph(base_family = "sans") +
    theme(
      plot.title = element_text(face = "bold", size = 16, hjust = 0.5),
      plot.subtitle = element_text(hjust = 0.5, color = "gray40"),
      legend.position = "right"
    )
  
  ggsave(output_file, plot = p, width = 16, height = 12, dpi = 300)
  cat(sprintf("✓ Comunidades salvas: %s\n", output_file))
}

################################################################################
# FUNÇÃO: Relatório
################################################################################
gerar_relatorio <- function(g, metricas, output_file = "network_relatorio.txt") {
  cat("\n📝 Gerando relatório estatístico...\n")
  
  sink(output_file)
  cat("================================================================================")
  cat("NETWORK ANALYSIS REPORT - ML FOR GEOGRAPHICAL INDICATIONS\n")
  cat("================================================================================")
  cat(sprintf("Execution date: %s\n\n", Sys.time()))
  
  cat("--------------------------------------------------------------------------------\n")
  cat("GENERAL NETWORK STATISTICS\n")
  cat("--------------------------------------------------------------------------------\n")
  cat(sprintf("Number of nodes: %d\n", vcount(g)))
  cat(sprintf("Number of edges: %d\n", ecount(g)))
  cat(sprintf("Density: %.4f\n", edge_density(g)))
  cat(sprintf("Transitivity (clustering coefficient): %.4f\n", transitivity(g)))
  cat(sprintf("Network diameter: %d\n", diameter(g)))
  cat(sprintf("Average distance: %.2f\n\n", mean_distance(g)))
  
  cat("--------------------------------------------------------------------------------\n")
  cat("TOP 15 NÓS POR GRAU (DEGREE CENTRALITY)\n")
  cat("--------------------------------------------------------------------------------\n")
  print(head(metricas %>% select(Node, Degree) %>% arrange(desc(Degree)), 15))
  cat("\n")
  
  cat("--------------------------------------------------------------------------------\n")
  cat("TOP 15 NÓS POR BETWEENNESS CENTRALITY\n")
  cat("--------------------------------------------------------------------------------\n")
  print(head(metricas %>% select(Node, Betweenness) %>% arrange(desc(Betweenness)), 15))
  cat("\n")
  
  cat("--------------------------------------------------------------------------------\n")
  cat("TOP 15 NÓS POR EIGENVECTOR CENTRALITY\n")
  cat("--------------------------------------------------------------------------------\n")
  print(head(metricas %>% select(Node, Eigenvector) %>% arrange(desc(Eigenvector)), 15))
  cat("\n")
  
  cat("--------------------------------------------------------------------------------\n")
  cat("COMUNIDADES DETECTADAS (LOUVAIN)\n")
  cat("--------------------------------------------------------------------------------\n")
  communities_table <- table(V(g)$community)
  print(communities_table)
  cat("\n")
  
  for (comm in sort(unique(V(g)$community))) {
    cat(sprintf("\n=== COMUNIDADE %d (n=%d) ===\n", comm, sum(V(g)$community == comm)))
    nodes_comm <- V(g)$name[V(g)$community == comm]
    cat(paste(nodes_comm, collapse = ", "), "\n")
  }
  
  cat("\n================================================================================\n")
  sink()
  
  cat(sprintf("✓ Relatório estatístico salvo: %s\n", output_file))
}

################################################################################
# FUNÇÃO: Salvar grafo
################################################################################
salvar_grafo <- function(g, filename = "network_completa.graphml") {
  write_graph(g, filename, format = "graphml")
  cat(sprintf("✓ Grafo salvo: %s (importável em Gephi)\n", filename))
}

################################################################################
# FUNÇÃO: Plot de rede com clusters temáticos sobrepostos
################################################################################
plot_network_clusters <- function(g, output_file = "network_clusters.png") {
  cat("📊 Gerando visualização da rede com clusters temáticos...\n")
  
  # Verificar se arquivo de clusters existe
  cluster_file <- "../3-CLUSTERS/cluster_resultados.csv"
  if (!file.exists(cluster_file)) {
    cat("⚠️  Arquivo de clusters não encontrado. Pulando visualização.\n")
    return(invisible(NULL))
  }
  
  # Carregar clusters
  clusters_data <- read.csv(cluster_file)
  caminho_bib <- "../corpus.bib"
  bib_data <- bib2df(caminho_bib)
  
  # Nomes dos clusters
  cluster_names <- c(
    "1" = "Mineração de Dados e CT",
    "2" = "ML em Conservação",
    "3" = "ML e Povos Indígenas",
    "4" = "Etnobotânica Aplicada",
    "5" = "ML e Mudanças Climáticas"
  )
  
  # Cores dos clusters
  cores_clusters <- c("#E41A1C", "#377EB8", "#4DAF4A", "#FF7F00", "#984EA3")
  
  # Adicionar atributo de cluster aos vértices se possível
  # (isso é conceitual - na prática features não têm clusters diretos)
  # Vamos colorir por comunidade mas rotular com referência aos clusters
  
  tg <- as_tbl_graph(g)
  
  p <- ggraph(tg, layout = "fr") +
    geom_edge_link(aes(width = weight, alpha = weight), color = "gray50") +
    geom_node_point(aes(size = degree(g), color = as.factor(V(g)$community)), alpha = 0.8) +
    geom_node_text(aes(label = name), repel = TRUE, size = 3, fontface = "bold") +
    scale_edge_width(range = c(0.5, 3)) +
    scale_edge_alpha(range = c(0.3, 0.8)) +
    scale_size_continuous(range = c(3, 12)) +
    scale_color_viridis_d(option = "plasma", begin = 0.1, end = 0.9) +
    labs(
      title = "Rede de Co-ocorrências com Comunidades Detectadas",
      subtitle = sprintf("%d nós, %d arestas | %d comunidades", 
                         vcount(g), ecount(g), length(unique(V(g)$community))),
      color = "Comunidade",
      size = "Grau"
    ) +
    theme_graph(base_family = "sans") +
    theme(
      plot.title = element_text(face = "bold", size = 16, hjust = 0.5),
      plot.subtitle = element_text(hjust = 0.5, color = "gray40", size = 12),
      legend.position = "right"
    )
  
  ggsave(output_file, plot = p, width = 16, height = 12, dpi = 300)
  cat(sprintf("✓ Rede com clusters salva: %s\n", output_file))
}

################################################################################
# EXECUÇÃO PRINCIPAL
################################################################################
main <- function() {
  caminho_bib <- "../../1-RSTUDIO/corpus.bib"
  
  if (!file.exists(caminho_bib)) {
    stop("❌ Erro: Arquivo .bib não encontrado em: ", caminho_bib)
  }
  
  # 1. Extrair co-ocorrências
  dados <- extrair_coocorrencias(caminho_bib)
  
  # 2. Construir rede completa
  g <- construir_rede(dados$presenca, min_coocorrencia = 3)
  
  # 3. Calcular métricas
  metricas <- calcular_metricas_rede(g)
  
  # 4. Detectar comunidades
  g <- detectar_comunidades(g)
  
  # 5. Visualizations
  cat("📊 Gerando visualizações...\n")
  plot_network_completa(g)
  plot_network_especifica(dados$presenca, dados$algoritmos, dados$metodos_etnograficos,
                          "Rede Algoritmos ML × Métodos Etnográficos", "network_ml_metodos.png")
  plot_network_especifica(dados$presenca, dados$algoritmos, dados$conhecimentos,
                          "Rede Algoritmos ML × Temas de Conhecimentos Tradicionais", "network_ml_temas.png")
  plot_network_tripartida(dados$presenca, dados$algoritmos, dados$metodos_etnograficos, dados$conhecimentos)
  plot_centrality_metrics(metricas)
  plot_communities(g)
  plot_network_clusters(g)
  
  # 6. Relatório
  gerar_relatorio(g, metricas)
  
  # 7. Salvar grafo
  cat("\n")
  salvar_grafo(g)
  
  cat("\n")
  cat("================================================================================\n")
  cat("✅ ANÁLISE DE REDES CONCLUÍDA COM SUCESSO!\n")
  cat("================================================================================\n")
}

tryCatch({
  main()
}, error = function(e) {
  cat("\n❌ ERRO durante a execução:\n")
  cat(conditionMessage(e), "\n")
})
