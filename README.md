# 🧠 Missão Corpo Humano

Jogo educativo 2D top-down desenvolvido em **Godot Engine 4.6**, criado como projeto de extensão da disciplina **T166 – Experimentação de Protótipos** (Universidade de Fortaleza - UNIFOR), com o objetivo de ensinar os sistemas do corpo humano para alunos do 4º ano do Ensino Fundamental de forma lúdica e interativa.

## 🎮 Sobre o jogo

Você controla um personagem que explora um laboratório e precisa coletar itens espalhados pelo mapa. Cada item representa um **sistema do corpo humano**:

| Item | Sistema |
|---|---|
| 🍎 Maçã | Sistema Digestório |
| 🩸 Gota de sangue | Sistema Circulatório |
| ⚡ Raio | Sistema Nervoso |
| 🦴 Osso | Sistema Esquelético |
| 🫧 Bolha | Sistema Respiratório |
| 🏋️ Haltere | Sistema Muscular |
| 👁️ Olho | Sistema Sensorial |
| 🛡️ Escudo | Sistema Imunológico |

Ao tocar em um item, uma **pergunta de múltipla escolha** sobre aquele sistema aparece. O jogador tem até 2 tentativas para acertar; ao responder corretamente, o item é coletado e uma explicação educativa é exibida.

### Objetivo e desafio
- Colete pelo menos **6 dos 8 itens** disponíveis no mapa.
- Você tem **2 minutos** (120s) para completar a missão.
- Inimigos patrulham o mapa e devem ser evitados.
- Ao final, uma tela de **Vitória** ou **Game Over** é exibida conforme o desempenho.

## 🕹️ Controles

| Ação | Tecla |
|---|---|
| Mover | Setas direcionais / WASD |

## 🛠️ Tecnologias

- **Engine:** Godot 4.6 (GDScript)
- **Arte:** sprites pixel art (personagem, itens, inimigos, tileset)
- **Áudio:** efeitos sonoros e trilha em 8-bit
- **Dados:** perguntas armazenadas em `perguntas.json`, carregadas dinamicamente por sistema

## 📂 Estrutura do projeto

```
├── main.tscn / main.gd          # Cena principal do jogo (mapa, spawns, HUD)
├── QuestionManager.gd           # Autoload responsável pelo estado do jogo, quiz e timer
├── quiz_ui.tscn / quiz_ui.gd    # Interface do quiz (perguntas e alternativas)
├── item.tscn / item.gd          # Comportamento dos itens colecionáveis
├── enemy*.tscn / enemy*.gd      # Inimigos com rotas de patrulha
├── control.tscn / control.gd    # Tela de controles/instruções
├── Tutorial.tscn / tutorial.gd  # Tutorial inicial
├── progresso.tscn / progresso.gd# Barra de progresso e timer visual
├── transition.tscn/.gdshader    # Transições de cena (shader)
├── perguntas.json               # Banco de perguntas por sistema do corpo humano
├── Cenas/                       # Player, menu, vitória e game over
├── Missao Corpo Humano/         # Assets próprios (sprites, tileset, áudios)
└── Caio coisas/                 # Assets adicionais (fontes, UI, sons, sprites de inimigos)
```

## ▶️ Como rodar

1. Instale o [Godot Engine 4.6](https://godotengine.org/download) ou superior.
2. Clone este repositório:
   ```bash
   git clone <url-deste-repositorio>
   ```
3. Abra o Godot, clique em **Importar**, selecione a pasta clonada e abra o `project.godot`.
4. Pressione **F5** (ou o botão de play) para rodar o jogo.

## 🎓 Contexto acadêmico

Projeto desenvolvido para o **Projeto Extensionista** da disciplina T166 (Prof.ª Ma. Karoline Rodrigues Lima), com apresentação no **Tech Day** da UNIFOR, como forma de integração entre a universidade e a Escola Yolanda Queiroz.

## ✍️ Autor

Desenvolvido por **Caio Portela** ([GitHub](https://github.com/CaioPortela17)).
