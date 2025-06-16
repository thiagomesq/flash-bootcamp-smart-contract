-include .env

.PHONY: all test clean deploy fund help install snapshot format anvil zktest

DEFAULT_ANVIL_KEY := 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
DEFAULT_ZKSYNC_LOCAL_KEY := 0x7726827caac94a7f9e1b160f7ea819f172f7b6f9d2a97f992c38edeab82d4110

foundryup:; foundryup -i 1.0.0

all: clean remove install update build

# Clean the repo
clean  :; forge clean

# Remove modules
remove :; rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m "modules"

install :; forge install cyfrin/foundry-devops && forge install smartcontractkit/chainlink-brownie-contracts && forge install foundry-rs/forge-std

# Update Dependencies
update:; forge update

build:; forge build

zkbuild :; forge build --zksync

test :; forge test

zktest :; foundryup-zksync && forge test --zksync && foundryup -i 1.0.0

snapshot :; forge snapshot

format :; forge fmt

anvil :; anvil --dump-state task_manager.json --load-state task_manager.json

save-anvil :; anvil --dump-state task_manager.json

load-anvil :; anvil -m 'test test test test test test test test test test test junk' --steps-tracing --block-time 1 --dump-state task_manager.json --load-state task_manager.json

zk-anvil :; npx zksync-cli dev start

deploy:
	@forge script script/DeployTaskManager.s.sol:DeployTaskManager $(NETWORK_ARGS)

NETWORK_ARGS := --rpc-url http://localhost:8545 --private-key $(DEFAULT_ANVIL_KEY) --broadcast

ifeq ($(findstring --network sepolia,$(ARGS)),--network sepolia)
	NETWORK_ARGS := --rpc-url $(SEPOLIA_RPC_URL) --account $(ACCOUNT) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv
else ifeq ($(findstring --network polygon-amoy,$(ARGS)),--network polygon-amoy)
	NETWORK_ARGS := --rpc-url $(POLYGON_AMOY_RPC_URL) --account $(ACCOUNT) --broadcast --verify --etherscan-api-key $(POLYGON_API_KEY) -vvvv
endif

create-task:
	@forge script script/Interactions.s.sol:CreateTask $(NETWORK_ARGS)

complete-task:
	@forge script script/Interactions.s.sol:CompleteTask $(NETWORK_ARGS)