## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```

# TaskManager Smart Contract

A smart contract for task management with staking system on Ethereum, developed during the Flash Bootcamp.

## 📋 Overview

TaskManager is a contract that allows users to create and manage tasks with an incentive system based on staking. Users must deposit a minimum amount of ETH when creating a task, encouraging deadline compliance.

## 🚀 Features

- ✅ **Create Tasks**: Create tasks with title, description, deadline and mandatory stake
- ✅ **Complete Tasks**: Mark tasks as completed
- ✅ **View Tasks**: Query individual tasks or all your tasks
- ✅ **Staking System**: Minimum deposit of 10 wei to create tasks
- ✅ **Ownership Control**: Only the creator can complete their tasks

## 📊 Task Structure

```solidity
struct Task {
    uint256 id;           // Unique task ID
    uint256 stake;        // Deposited value in wei
    string title;         // Task title
    string description;   // Task description
    uint256 createdAt;    // Creation timestamp
    uint256 completedAt;  // Completion timestamp
    uint256 dueDate;      // Task deadline
    bool isCompleted;     // Completion status
    address owner;        // Creator address
}
```

## 🛠️ Installation and Setup

### Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation)
- Node.js (for auxiliary scripts)
- Make (to use Makefile shortcuts)

### Installation

```bash
# Clone the repository
git clone <repository-url>
cd smart-contract

# Complete project setup
make all

# Or install dependencies manually
make install
```

## 🏗️ Development

### Initial Setup

```bash
# Complete setup (clean + install + update + build)
make all

# Update Foundry to specific version
make foundryup

# Clean build artifacts
make clean

# Reinstall dependencies
make remove && make install
```

### Build and Tests

```bash
# Build project
make build

# Build for zkSync
make zkbuild

# Run tests
make test

# Run zkSync tests
make zktest

# Gas analysis
make snapshot

# Code formatting
make format
```

## 🌐 Development Environment

### Anvil (Local Node)

```bash
# Start Anvil with persistent state
make anvil

# Start Anvil saving state
make save-anvil

# Load Anvil with specific configurations
make load-anvil

# Start zkSync local
make zk-anvil
```

## 📦 Deploy

### Local Deploy (Anvil)

```bash
# Deploy on Anvil (localhost)
make deploy

# With custom arguments
make deploy ARGS="--network localhost"
```

### Deploy on Testnets

```bash
# Deploy on Sepolia
make deploy ARGS="--network sepolia"

# Deploy on Polygon Amoy
make deploy ARGS="--network polygon-amoy"
```

**Required configuration in `.env` file:**

```bash
# .env
SEPOLIA_RPC_URL=https://sepolia.infura.io/v3/your-key
POLYGON_AMOY_RPC_URL=https://rpc-amoy.polygon.technology
ACCOUNT=your-account-name
ETHERSCAN_API_KEY=your-etherscan-key
POLYGON_API_KEY=your-polygonscan-key
```

## 🎯 Contract Interactions

### Using Make Commands

```bash
# Create a new task
make create-task

# Complete an existing task
make complete-task

# For different networks
make create-task ARGS="--network sepolia"
make complete-task ARGS="--network polygon-amoy"
```

### Direct Contract Usage

```solidity
// Create a task with 1 ETH stake
taskManager.createTask{value: 1 ether}(
    "Study Solidity",
    "Complete blockchain development course",
    block.timestamp + 7 days
);

// Complete task
taskManager.completeTask(0);

// Query tasks
Task memory task = taskManager.getTask(0);
Task[] memory allTasks = taskManager.getTasks();
uint256 count = taskManager.getTasksCount();
```

## 🚨 Error Handling

The contract implements custom errors for better debugging:

- `TaskManager__InsufficientStake`: Insufficient stake (minimum 10 wei)
- `TaskManager__TaskNotFound`: Task not found
- `TaskManager__Unauthorized`: Unauthorized user
- `TaskManager__TaskAlreadyCompleted`: Task already completed

## 📡 Events

```solidity
event TaskCreated(
    uint256 indexed id,
    uint256 indexed stake,
    string title,
    string description,
    uint256 createdAt,
    uint256 completedAt,
    uint256 indexed dueDate,
    bool isCompleted,
    address owner
);

event TaskCompleted(
    uint256 indexed id,
    uint256 indexed createdAt,
    uint256 indexed completedAt
);
```

## 🧪 Testing

```bash
# Run all tests
make test

# Tests with higher verbosity
forge test -vvv

# Specific test
forge test --match-test testCreateTask

# zkSync tests
make zktest
```

## 📋 Available Commands

| Command | Description |
|---------|-------------|
| `make all` | Complete project setup |
| `make build` | Compile contracts |
| `make test` | Run tests |
| `make deploy` | Local deploy |
| `make anvil` | Start local node |
| `make create-task` | Create new task |
| `make complete-task` | Complete task |
| `make format` | Format code |
| `make snapshot` | Gas analysis |
| `make clean` | Clean artifacts |

## 🔒 Security

- **Access Control**: Only owners can complete their tasks
- **Input Validation**: Minimum stake verification
- **Overflow Prevention**: Using Solidity 0.8.26+
- **Error Handling**: Custom errors for better debugging

## 🛣️ Roadmap

- [ ] Reward system for tasks completed on time
- [ ] Implement penalties for overdue tasks
- [ ] Web interface for contract interaction
- [ ] Category system for tasks
- [ ] ERC-20 token integration

## 📚 Foundry Documentation

For more information about Foundry:
- [Foundry Book](https://book.getfoundry.sh/)
- [Forge Documentation](https://book.getfoundry.sh/forge/)
- [Cast Documentation](https://book.getfoundry.sh/cast/)
- [Anvil Documentation](https://book.getfoundry.sh/anvil/)

## 📄 License

MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributions

Contributions are welcome! Please open an issue first to discuss significant changes.

---

**Developed during the Flash Blockchain Bootcamp** 🚀

---

# TaskManager Smart Contract

Um contrato inteligente para gerenciamento de tarefas com sistema de stake em Ethereum, desenvolvido durante o Flash Bootcamp.

## 📋 Visão Geral

O TaskManager é um contrato que permite aos usuários criar e gerenciar tarefas com um sistema de incentivo baseado em stake. Os usuários devem depositar uma quantia mínima de ETH ao criar uma tarefa, incentivando o cumprimento dos prazos.

## 🚀 Funcionalidades

- ✅ **Criar Tarefas**: Crie tarefas com título, descrição, prazo e stake obrigatório
- ✅ **Completar Tarefas**: Marque tarefas como concluídas
- ✅ **Visualizar Tarefas**: Consulte tarefas individuais ou todas as suas tarefas
- ✅ **Sistema de Stake**: Depósito mínimo de 10 wei para criar tarefas
- ✅ **Controle de Propriedade**: Apenas o criador pode completar suas tarefas

## 📊 Estrutura da Tarefa

```solidity
struct Task {
    uint256 id;           // ID único da tarefa
    uint256 stake;        // Valor depositado em wei
    string title;         // Título da tarefa
    string description;   // Descrição da tarefa
    uint256 createdAt;    // Timestamp de criação
    uint256 completedAt;  // Timestamp de conclusão
    uint256 dueDate;      // Prazo da tarefa
    bool isCompleted;     // Status de conclusão
    address owner;        // Endereço do criador
}
```

## 🛠️ Instalação e Setup

### Pré-requisitos

- [Foundry](https://book.getfoundry.sh/getting-started/installation)
- Node.js (para scripts auxiliares)
- Make (para usar os atalhos do Makefile)

### Instalação

```bash
# Clone o repositório
git clone <repository-url>
cd smart-contract

# Setup completo do projeto
make all

# Ou instale dependências manualmente
make install
```

## 🏗️ Desenvolvimento

### Setup Inicial

```bash
# Setup completo (clean + install + update + build)
make all

# Atualizar Foundry para versão específica
make foundryup

# Limpar artefatos de build
make clean

# Reinstalar dependências
make remove && make install
```

### Build e Testes

```bash
# Build do projeto
make build

# Build para zkSync
make zkbuild

# Executar testes
make test

# Executar testes zkSync
make zktest

# Análise de gas
make snapshot

# Formatação de código
make format
```

## 🌐 Ambiente de Desenvolvimento

### Anvil (Node Local)

```bash
# Iniciar Anvil com estado persistente
make anvil

# Iniciar Anvil salvando estado
make save-anvil

# Carregar Anvil com configurações específicas
make load-anvil

# Iniciar zkSync local
make zk-anvil
```

## 📦 Deploy

### Deploy Local (Anvil)

```bash
# Deploy no Anvil (localhost)
make deploy

# Com argumentos customizados
make deploy ARGS="--network localhost"
```

### Deploy em Testnets

```bash
# Deploy na Sepolia
make deploy ARGS="--network sepolia"

# Deploy na Polygon Amoy
make deploy ARGS="--network polygon-amoy"
```

**Configuração necessária no arquivo `.env`:**

```bash
# .env
SEPOLIA_RPC_URL=https://sepolia.infura.io/v3/your-key
POLYGON_AMOY_RPC_URL=https://rpc-amoy.polygon.technology
ACCOUNT=your-account-name
ETHERSCAN_API_KEY=your-etherscan-key
POLYGON_API_KEY=your-polygonscan-key
```

## 🎯 Interações com o Contrato

### Usando Make Commands

```bash
# Criar uma nova tarefa
make create-task

# Completar uma tarefa existente
make complete-task

# Para diferentes redes
make create-task ARGS="--network sepolia"
make complete-task ARGS="--network polygon-amoy"
```

### Uso Direto do Contrato

```solidity
// Criar uma tarefa com 1 ETH de stake
taskManager.createTask{value: 1 ether}(
    "Estudar Solidity",
    "Completar curso de desenvolvimento blockchain",
    block.timestamp + 7 days
);

// Completar tarefa
taskManager.completeTask(0);

// Consultar tarefas
Task memory task = taskManager.getTask(0);
Task[] memory allTasks = taskManager.getTasks();
uint256 count = taskManager.getTasksCount();
```

## 🚨 Tratamento de Erros

O contrato implementa erros customizados para melhor debugging:

- `TaskManager__InsufficientStake`: Stake insuficiente (mínimo 10 wei)
- `TaskManager__TaskNotFound`: Tarefa não encontrada
- `TaskManager__Unauthorized`: Usuário não autorizado
- `TaskManager__TaskAlreadyCompleted`: Tarefa já foi concluída

## 📡 Eventos

```solidity
event TaskCreated(
    uint256 indexed id,
    uint256 indexed stake,
    string title,
    string description,
    uint256 createdAt,
    uint256 completedAt,
    uint256 indexed dueDate,
    bool isCompleted,
    address owner
);

event TaskCompleted(
    uint256 indexed id,
    uint256 indexed createdAt,
    uint256 indexed completedAt
);
```

## 🧪 Testes

```bash
# Executar todos os testes
make test

# Testes com maior verbosidade
forge test -vvv

# Teste específico
forge test --match-test testCreateTask

# Testes zkSync
make zktest
```

## 📋 Comandos Disponíveis

| Comando | Descrição |
|---------|-----------|
| `make all` | Setup completo do projeto |
| `make build` | Compilar contratos |
| `make test` | Executar testes |
| `make deploy` | Deploy local |
| `make anvil` | Iniciar node local |
| `make create-task` | Criar nova tarefa |
| `make complete-task` | Completar tarefa |
| `make format` | Formatar código |
| `make snapshot` | Análise de gas |
| `make clean` | Limpar artefatos |

## 🔒 Segurança

- **Controle de Acesso**: Apenas proprietários podem completar suas tarefas
- **Validação de Entrada**: Verificação de stake mínimo
- **Prevenção de Overflow**: Uso do Solidity 0.8.26+
- **Tratamento de Erros**: Errors customizados para melhor debugging

## 🛣️ Roadmap

- [ ] Sistema de recompensas para tarefas concluídas no prazo
- [ ] Implementar penalidades para tarefas em atraso
- [ ] Interface web para interação com o contrato
- [ ] Sistema de categorias para tarefas
- [ ] Integração com tokens ERC-20

## 📚 Documentação Foundry

Para mais informações sobre o Foundry:
- [Foundry Book](https://book.getfoundry.sh/)
- [Forge Documentation](https://book.getfoundry.sh/forge/)
- [Cast Documentation](https://book.getfoundry.sh/cast/)
- [Anvil Documentation](https://book.getfoundry.sh/anvil/)

## 📄 Licença

MIT License - veja o arquivo [LICENSE](LICENSE) para detalhes.

## 🤝 Contribuições

Contribuições são bem-vindas! Por favor, abra uma issue primeiro para discutir mudanças significativas.

---

**Desenvolvido durante o Flash Bootcamp Blockchain** 🚀
