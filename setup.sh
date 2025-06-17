#!/bin/bash

echo "🔒 启动 Boundless 安装脚本（增强安全版）..."

# 暂时禁用 bash 历史记录（防止私钥被记录）
set +o history

# 获取用户输入（RPC 和私钥）
read -p "请输入 Base 主网 RPC 地址: " RPC_URL
read -p "请输入钱包私钥（不会保存）: " PRIVATE_KEY

# 恢复 bash 历史记录
set -o history

# 安装 Rust
echo "📦 安装 Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"

# 安装 Risc0 工具链
echo "📦 安装 Risc0..."
curl -L https://risczero.com/install | bash
source ~/.bashrc
rzup install

# 克隆 Boundless 仓库
echo "📂 克隆 Boundless 仓库..."
git clone https://github.com/boundless-xyz/boundless
cd boundless
git checkout release-0.10

# 安装 bento-client
echo "📦 安装 bento-client..."
cargo install --git https://github.com/risc0/risc0 bento-client --bin bento_cli

# 更新 PATH
echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# 安装 Boundless CLI
echo "📦 安装 boundless-cli..."
cargo install --locked boundless-cli

# ✅ 临时导出变量（不写入文件）
export RPC_URL="$RPC_URL"
export PRIVATE_KEY="$PRIVATE_KEY"

# ✅ 执行 CLI 命令（无需 .env 文件）
echo "✅ 开始 USDC 质押（1枚）..."
boundless --rpc-url "$RPC_URL" --private-key "$PRIVATE_KEY" account deposit-stake 1

echo "✅ 开始 ETH 存款（0.001 枚）..."
boundless --rpc-url "$RPC_URL" --private-key "$PRIVATE_KEY" account deposit 0.001

echo "🎉 所有操作已完成（未保存私钥）！请手动保管好您的钱包信息。"
