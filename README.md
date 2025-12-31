# 🎭 IMPOSTOR - Jogo de Festa para iOS

Um aplicativo nativo em SwiftUI para o popular jogo de festa "Impostor" (estilo TikTok).

## 📱 Conceito do Jogo

Um grupo de jogadores recebe a mesma palavra secreta, mas um deles (o Impostor) não recebe a palavra. Os jogadores precisam dar dicas sobre suas palavras e tentar descobrir quem é o infiltrado.

## ✨ Funcionalidades Implementadas

### 1. **Tela de Configuração (SetupView)**
- Seleção do número de jogadores (3 a 12)
- Escolha de categoria (Comida, Lugares, Profissões)
- Interface moderna com gradiente e animações
- Botões com feedback háptico

### 2. **Sistema de Revelação (RevealView)**
- **"Hold to Reveal"**: Mecânica de pressionar e segurar para revelar a palavra
- Proteção contra espiadelas: a palavra só aparece enquanto o dedo está pressionado
- Feedback háptico ao revelar e esconder
- Design diferenciado para o Impostor (tema vermelho)
- Indicador visual do progresso dos jogadores
- Transição suave entre jogadores

### 3. **Tela de Discussão (DiscussionView)**
- Timer regressivo de 2 minutos
- Animação de progresso circular
- Mudança de cor nos últimos 10 segundos (alerta vermelho)
- Haptic feedback nos últimos 5 segundos
- Instruções claras do jogo
- Botão para reiniciar o jogo

## 🎨 Design & UX

### Haptic Feedback
- ✅ Botões de configuração (light)
- ✅ Início do jogo (medium)
- ✅ Revelação de palavra (light)
- ✅ Mudança de jogador (medium)
- ✅ Início da discussão (heavy)
- ✅ Contagem regressiva final (medium)
- ✅ Fim do tempo (heavy)

### Paleta de Cores
- **Setup**: Azul e Roxo (confiável e moderno)
- **Jogador Normal**: Verde e Azul (positivo)
- **Impostor**: Vermelho e Laranja (tensão)
- **Discussão**: Roxo e Azul (neutro)
- **Alerta**: Vermelho e Laranja (urgência)

### Animações
- Transições suaves entre estados do jogo
- Scale effect ao pressionar cards
- Bounce effect nos ícones
- Gradiente animado no background
- Progress ring animado no timer

## 📦 Estrutura do Projeto

```
imposter/
├── Models/
│   └── GameModels.swift          # Enums e structs do jogo
├── ViewModels/
│   └── GameViewModel.swift       # Lógica de negócio e estado
├── Views/
│   ├── SetupView.swift          # Configuração do jogo
│   ├── RevealView.swift         # Revelação das palavras
│   └── DiscussionView.swift     # Fase de discussão
├── ContentView.swift            # View principal com navegação
└── imposterApp.swift            # Entry point
```

## 🎯 Categorias Implementadas

### 🍕 Comida
Pizza, Sushi, Hambúrguer, Sorvete, Lasanha, Tacos, Churrasco, Feijoada, Macarrão, Chocolate

### 🏖️ Lugares
Praia, Cinema, Parque, Shopping, Hospital, Escola, Restaurante, Academia, Biblioteca, Aeroporto

### 💼 Profissões
Médico, Professor, Engenheiro, Chef, Piloto, Advogado, Artista, Bombeiro, Jornalista, Cientista

## 🚀 Como Usar

1. **Abra o app** e configure:
   - Número de jogadores (3-12)
   - Categoria desejada

2. **Toque em "Iniciar Jogo"**

3. **Para cada jogador**:
   - Passe o celular para o jogador da vez
   - **Pressione e segure** o card central
   - Memorize sua palavra (ou descubra se é o impostor)
   - **Solte o dedo** para esconder
   - Toque em "Próximo Jogador"

4. **Durante a discussão**:
   - Cada jogador dá uma dica
   - O impostor tenta adivinhar e se misturar
   - Votem no suspeito

5. **Ao final do tempo**:
   - Revelem o impostor
   - Iniciem um novo jogo

## 🔐 Segurança do Jogo

- ✅ A palavra só aparece enquanto está sendo pressionada
- ✅ O índice do impostor é gerado aleatoriamente
- ✅ Não há como o jogador ver a palavra do próximo
- ✅ Sistema de "passar o celular" garante privacidade

## 🛠️ Tecnologias Utilizadas

- **SwiftUI**: Framework UI declarativo
- **Combine**: Gerenciamento reativo de estado
- **UIKit** (Haptics): Feedback tátil
- **Timer**: Contagem regressiva
- **@StateObject/@ObservedObject**: Gerenciamento de estado

## 📱 Requisitos

- iOS 15.0+
- Xcode 14.0+
- Swift 5.7+

## 🎮 Possíveis Melhorias Futuras

- [ ] Adicionar mais categorias
- [ ] Permitir categorias customizadas
- [ ] Histórico de jogos
- [ ] Sistema de pontuação
- [ ] Modo "2 impostores"
- [ ] Palavras relacionadas (ao invés de nenhuma palavra para o impostor)
- [ ] Sons além dos haptics
- [ ] Modo dark/light manual
- [ ] Compartilhar resultados
- [ ] Integração com Game Center

## 👨‍💻 Desenvolvido por

Thiago dos Santos Gomes - Desenvolvido como MVP de jogo de festa moderno em SwiftUI.

---

**Divirta-se descobrindo o impostor! 🎭🔍**

