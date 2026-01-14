# Desafio Técnico Empiricus/BTG Pactual: Listagem de Assinaturas Flutter

Este app Flutter com Clean Architecture, BLoC, Get it, Sharedpreferences, testes e deeplinks, **consumindo API real** é a resolução de um desafio técnico para a **Empiricus/BTG Pactual**.

**Objetivo:** Mostrar minha capacidade de trabalhar com código escalável, modular e testável para aplicações de grande porte.

## Demonstração
<img src="https://github.com/beatriz-dadalto/flutter-subscriptions-clean-arch-dio-bloc-getit-mocktail-tests/blob/main/app-empiricus-subscriptions.gif" width="370px" alt="demo-image"/>

---
## Funcionalidades Implementadas

#### Requisitos do desafio valendo pontos

- Listagem de Assinaturas
- Consumo de dados em tempo real do endpoint: https://empiricus-app.empiricus.com.br/mock/list.json
- Navegação fluida e otimizada para performance
- Tela de Detalhes da Assinatura
- Exibe nome, descrição, imagem grande, autores e lista de features
- **Tratamento de Erro**: Em caso de falha (ex: slug inválido), uma NotFoundScreen personalizada é exibida
- Feedback visual claro ao usuário

#### Bônus Implementados

- **Splash Screen**
- Tela inicial com o logo da Empiricus para uma experiência de usuário aprimorada
- **Tela de Login**
- Autenticação com usuário e senha fixos (veja seção Credenciais de Login)
- Exibição de SnackBar de erro em caso de falha na autenticação
- Persistência de Estado: O estado de autenticação é persistido usando SharedPreferences, garantindo que o usuário permaneça logado entre as sessões
- Deeplinks (Android)
- Tratamento Visual de Erros
- Cobertura de cenários críticos com testes de unidade (Use Cases, BLoCs) e testes de widgets

---


### Habilidades demonstradas para demonstrar domínio técnico, atenção à UX e preparo para desafios reais em Flutter:

- Testes automatizados cobrindo lógica e UI
- Organização
- Boas práticas de engenharia (SOLID, DI, separação de camadas)
- Clean Architecture (camadas: presentation, domain, data, core)
- Gerenciamento de estado reativo com BLoC
- Consumo de API REST em tempo real
- Navegação avançada com GoRouter e deeplinks
- Tratamento visual de erros com SnackBars e NotFoundScreen
- Persistência de estado com SharedPreferences

```
lib/
├── core/           # Utilitários, temas, tratamento de erros (Failures/Exceptions), DI (GetIt), ApiClient, Result type
├── data/           # Implementações de repositórios, Data Sources (remoto/local), Models (serialização JSON)
├── domain/         # Regras de negócio, Entities (classes puras), Use Cases, Interfaces de Repositórios
├── presentation/   # Camada de UI: BLoCs (gerenciamento de estado), Screens (telas), Widgets (componentes reutilizáveis)
└── routes/         # Configuração do GoRouter para navegação e deeplinks

test/               # Testes unitários e de widget

```

### Fluxo de dados
```
UI (Screens) → BLoCs → Use Cases → Repositories → Data Sources (API)
                ↓
            State Management (SharedPreferences)
```

## Como Executar o Projeto

Siga estes passos para configurar e rodar o aplicativo em seu ambiente local:

#### Versão Utilizada

- **Flutter SDK:** >=3.9.2
<br />

1.  **Clone o repositório:**

```bash
git clone https://github.com/beatriz-dadalto/flutter-subscriptions-clean-arch-bloc-getit-mocktail-tests.git
```
```bash
cd flutter-subscriptions-clean-arch-bloc-getit-mocktail-tests
```

2.  **Instale as dependências:**
```bash
flutter pub get
```

3.  **Execute o aplicativo:**
- Você deve ter um emulador ou disposito android
```bash
flutter run
```

---
## 🔒 Credenciais de Login

Para acessar as funcionalidades restritas do aplicativo, utilize as seguintes credenciais:

*   **Usuário:** `admin@email.com`
*   **Senha:** `123456`

*Essas credenciais estão fixas no código, conforme solicitado no desafio técnico.*

---

## Como Rodar os Testes

Para garantir a qualidade e robustez do código, o projeto inclui uma camada de testes focada em cenários críticos.

Execute todos os testes com:

```bash
flutter test
```


## Cenários de Teste Cobertos

### Testes de unidade e widgets
<img src="https://github.com/beatriz-dadalto/flutter-subscriptions-clean-arch-dio-bloc-getit-mocktail-tests/blob/main/coverage-test.png" alt="demo-image"/>

---


### Como Testar os Deeplinks (Android)


1.  Instale e rode o app em um dispositivo ou emulador Android. <br />
⚠️  **O app deve estar em execução para que os deeplinks funcionem corretamente.**
3.  No terminal, execute um dos comandos `adb` abaixo para abrir uma tela específica:

### Tela de listagem de assinaturas
```bash
adb shell am start -W -a android.intent.action.VIEW -d "empiricus://app/subscriptions" com.beatrizdadalto.empiricus_app_dev_beatriz_dadalto
```

### Tela de detalhe de uma assinatura específica
```bash
adb shell am start -W -a android.intent.action.VIEW -d "empiricus://app/subscriptions/as-melhores-acoes-da-bolsa" com.beatrizdadalto.empiricus_app_dev_beatriz_dadalto
```

### Deeplink para slug inválido (testa NotFoundScreen)
```bash
adb shell am start -W -a android.intent.action.VIEW -d "empiricus://app/subscriptions/slug-invalido" com.beatrizdadalto.empiricus_app_dev_beatriz_dadalto
```

### Deeplink para tela inicial
```bash
adb shell am start -W -a android.intent.action.VIEW -d "empiricus://app/" com.beatrizdadalto.empiricus_app_dev_beatriz_dadalto
```

---

* **Importante** Substitua `com.beatrizdadalto.empiricus_app_dev_beatriz_dadalto` pelo `applicationId` real do seu projeto Android, que pode ser encontrado no arquivo `android/app/build.gradle`.
<br/>
<br/>


## 🧑‍💻 Desenvolvido por

**Beatriz Dadalto**

*   [LinkedIn](https://www.linkedin.com/in/beatriz-dadalto/)
<br/>
<br/>


## 📝 Licença

Este projeto está licenciado sob a Licença MIT.
