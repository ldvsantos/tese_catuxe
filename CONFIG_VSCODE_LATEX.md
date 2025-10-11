# 📝 Configurações VS Code para LaTeX

## ⚙️ **CONFIGURAÇÕES RECOMENDADAS PARA ARQUIVOS .TEX**

### 1. **Word Wrap Automático para LaTeX**
Adicione no `settings.json` do VS Code:

```json
{
    "[latex]": {
        "editor.wordWrap": "on",
        "editor.wordWrapColumn": 80,
        "editor.rulers": [80]
    },
    "[tex]": {
        "editor.wordWrap": "on", 
        "editor.wordWrapColumn": 80,
        "editor.rulers": [80]
    }
}
```

### 2. **Acesso às Configurações:**
- **Atalho:** `Ctrl + Shift + P` → "Preferences: Open Settings (JSON)"
- **Menu:** File → Preferences → Settings → Ícone `{}` (Open Settings JSON)

### 3. **Opções de Word Wrap:**
- `"on"` - Quebra sempre
- `"off"` - Nunca quebra
- `"wordWrapColumn"` - Quebra na coluna especificada
- `"bounded"` - Quebra no viewport ou coluna (menor valor)

### 4. **Configurações Extras Úteis:**
```json
{
    "editor.fontFamily": "Consolas, 'Courier New', monospace",
    "editor.fontSize": 14,
    "editor.lineHeight": 1.5,
    "editor.minimap.enabled": false,
    "editor.scrollBeyondLastLine": false
}
```

## 🎯 **ATALHOS ÚTEIS:**
- `Alt + Z` - Toggle Word Wrap (ligar/desligar)
- `Ctrl + K, Ctrl + W` - Fechar todas as abas
- `Ctrl + K, Z` - Modo Zen (foco total)
- `Ctrl + B` - Toggle Sidebar

## 📚 **EXTENSÕES RECOMENDADAS PARA LaTeX:**
- LaTeX Workshop
- LaTeX Utilities  
- Spell Right (corretor ortográfico)