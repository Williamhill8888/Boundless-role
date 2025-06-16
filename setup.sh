#!/bin/bash

echo "🚀 开始安装 Boundless CLI 环境..."

# 输入提示
read -p "请输入您的 Sepolia RPC 地址: " RPC_URL
read -p "请输入您的钱包私钥: " PRIVATE_KEY

# 安装 Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env

# 安装 Risc0 工具链
curl -L https://risczero.com/install | bash
source ~/.bashrc
rzup install

# 克隆 Boundless 仓库
git clone https://github.com/boundless-xyz/boundless
cd boundless
git checkout release-0.10

# 安装 bento-client
cargo install --git https://github.com/risc0/risc0 bento-client --bin bento_cli

# 添加 PATH
echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# 安装 Boundless CLI
cargo install --locked boundless-cli

# 写入 .env 文件
cat <<EOF > .env.eth-sepolia
export RPC_URL=$RPC_URL
export PRIVATE_KEY=$PRIVATE_KEY
EOF

# 生效配置
source .env.eth-sepolia

# 执行质押
boundless account deposit-stake 10
boundless account deposit 0.1
