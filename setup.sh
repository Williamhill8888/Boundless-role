#!/bin/bash

echo "🚀 开始安装 Boundless CLI 环境..."

# 🧾 用户输入 RPC 和私钥（中文提示）
read -p "请输入您的 Sepolia RPC 地址: " RPC_URL
read -p "请输入您的钱包私钥: " PRIVATE_KEY

# ✅ 安装 Rust
echo "📦 正在安装 Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"

# ✅ 安装 Risc0 工具链
echo "📦 正在安装 Risc0 工具链..."
curl -L https://risczero.com/install | bash
source ~/.bashrc
rzup install

# ✅ 克隆 Boundless 仓库
echo "📂 正在克隆 Boundless 仓库..."
git clone https://github.com/boundless-xyz/boundless
cd boundless
git checkout release-0.10

# ✅ 安装 bento 客户端
echo "📦 正在安装 bento-client..."
cargo install --git https://github.com/risc0/risc0 bento-client --bin bento_cli

# ✅ 更新 PATH
echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# ✅ 安装 Boundless CLI
echo "📦 正在安装 boundless-cli..."
cargo install --locked boundless-cli

# ✅ 修改配置文件 .env.eth-sepolia（保留其他参数）
echo "🛠️ 正在配置 RPC 和私钥..."
if [ -f .env.eth-sepolia ]; then
  sed -i "s|^export RPC_URL=.*|export RPC_URL=$RPC_URL|" .env.eth-sepolia || echo "export RPC_URL=$RPC_URL" >> .env.eth-sepolia
  sed -i "s|^export PRIVATE_KEY=.*|export PRIVATE_KEY=$PRIVATE_KEY|" .env.eth-sepolia || echo "export PRIVATE_KEY=$PRIVATE_KEY" >> .env.eth-sepolia
else
  echo "export RPC_URL=$RPC_URL" > .env.eth-sepolia
  echo "export PRIVATE_KEY=$PRIVATE_KEY" >> .env.eth-sepolia
fi

# ✅ 应用配置
source .env.eth-sepolia

# ✅ 发起质押
echo "✅ 正在发起 USDC 质押..."
boundless account deposit-stake 10

echo "✅ 正在发起 ETH 质押..."
boundless account deposit 0.1

echo "🎉 安装与质押完成！"
