# 🎓 Tese de Doutorado - Branding Sustentável Catuxe

## 📋 **Informações do Projeto**

**Título:** Modelo Empírico de Branding Sustentável da Amazônia do Brasil: Uma Perspectiva Agroflorestal para Catuxe

**Autor:** Luiz Diego Vidal Santos  
**Orientador:** Prof. Dr. Francisco Sandro Rodrigues Holanda  
**Programa:** Ciência da Propriedade Intelectual - PPGPI/UFS  
**Instituição:** Universidade Federal de Sergipe  

## 📁 **Estrutura do Projeto**

### 🎯 **Arquivo Principal**
- `Tese-Catuxe-PPGPI.tex` - Documento principal da tese

### 📄 **Arquivos de Configuração**
- `ppgpi-abntex2.cls` - Classe LaTeX customizada para PPGPI
- `Doutorado-Catuxe.sty` - Arquivo de estilo da tese
- `references.bib` - Bibliografia em formato BibTeX

### 📚 **Conteúdo da Tese**
- `Conteudo/Introducao.tex` - Introdução
- `Conteudo/Referencial.tex` - Referencial teórico  
- `Artigos/Artigo_1.tex` - Artigo principal
- `Conteudo/Consideracoes.tex` - Considerações finais

### 🖼️ **Recursos**
- `Imagens/` - Figuras e logos (PDF)
- `apendece/` - Apêndices em PDF

### 📋 **Elementos Pré/Pós-textuais**
- `Pre_Textual/` - Dedicatória, agradecimentos, resumo, abstract, etc.
- `Pos_Textual/` - Apêndices

## 🔧 **Como Compilar**

### Processo Completo:
```bash
# 1. Compilar LaTeX
pdflatex Tese-Catuxe-PPGPI.tex

# 2. Processar bibliografia
bibtex Tese-Catuxe-PPGPI

# 3. Recompilar (2x para referências cruzadas)
pdflatex Tese-Catuxe-PPGPI.tex
pdflatex Tese-Catuxe-PPGPI.tex
```

### Resultado:
- **PDF Final:** `Tese-Catuxe-PPGPI.pdf` (~5.6 MB)

## ✅ **Status do Projeto**

- ✅ **Compilação:** Funcionando perfeitamente
- ✅ **Bibliografia:** 99%+ das referências resolvidas  
- ✅ **Figuras:** Todas as imagens carregando
- ✅ **Estrutura:** Conforme padrão ABNT/PPGPI
- ✅ **Backup:** Arquivos não utilizados preservados em `backup_arquivos_removidos/`

## 🎯 **Otimizações Realizadas**

1. **Limpeza de arquivos:** Removidos 95+ MB de arquivos desnecessários
2. **Resolução de conflitos:** Pacotes LaTeX corrigidos
3. **Bibliografia funcional:** Processo BibTeX operacional
4. **Organização:** Arquivos renomeados apropriadamente

## 🚀 **GitHub**

**Repositório:** https://github.com/vidalcenter/tese-doutorado-catuxe.git

---

*Projeto otimizado e funcional para defesa de tese de doutorado*  
*Última atualização: 11/10/2025*