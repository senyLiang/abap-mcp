# ABAP MCP Server - Team Setup Guide

A shared configuration package for running the **abap-mcp** MCP server with various AI tools (Claude Code, Claude Desktop, Cursor, Windsurf, Cline, etc.).

This package supports **two server implementations** — choose based on your access level:

| | JCo 版（完整版） | REST 版（轻量版） |
|---|---|---|
| **功能** | 120 个工具（读/写/调试/测试） | 核心工具（创建/读取/修改/激活） |
| **认证** | SNC (SSO) + Basic Auth | Basic Auth |
| **依赖** | Java 17 + SAP JCo + SNC lib | 无额外依赖（单文件 exe） |
| **平台** | Windows / macOS / Linux | Windows |
| **适合** | SAP 内部团队（有内部 GitHub + S-User） | 外部客户 / 合作伙伴 / 开源社区 |
| **许可证** | SAP 内部非官方项目 | MIT License |
| **源码** | SAP 内部 GitHub | [GitHub (公开)](https://github.com/HariePrasad/sap-abap-mcp-server) |

## Architecture

```
方案 A: JCo 版（完整版）
AI Tool (Claude/Cursor/etc.)
    ↓ MCP Protocol (stdio)
jco-service JAR (Spring Boot)
    ↓ RFC (JCo) + ADT REST (HTTP)
SAP System (S/4HANA, BTP ABAP, etc.)

方案 B: REST 版（轻量版）
AI Tool (Claude/Cursor/etc.)
    ↓ MCP Protocol (stdio)
abap-mcp.exe (Node.js self-contained)
    ↓ ADT REST (HTTP only)
SAP System (S/4HANA, BTP ABAP, etc.)
```

---

# 方案 A：JCo 版（完整版 - SAP 内部）

> 适用于 SAP 内部员工或拥有 SAP 内部 GitHub 权限的团队。

## Prerequisites

Before setup, ensure you have:

| # | Dependency | Source | Notes |
|---|-----------|--------|-------|
| 1 | Java 17+ | [Adoptium](https://adoptium.net/) | `java -version` to verify |
| 2 | Maven 3.8+ | [Maven](https://maven.apache.org/) | 用于构建 JAR |
| 3 | SAP JCo 3.1.x | SAP Support Portal (需 S-User) | Native library + JAR |
| 4 | SNC Library | SAP Secure Login Client | `sapcrypto.dll` |
| 5 | jco-service JAR | SAP 内部 GitHub（见下方） | MCP Server 本体 |

---

### 依赖 1：MCP Server JAR（核心服务）

这是整个 MCP Server 的核心，来自 SAP 内部社区项目。

| 项目 | 详情 |
|------|------|
| **Git 仓库** | `https://github.wdf.sap.corp/sap-managed-tm-ewm/ai-sap-abap-adt.git` |
| **性质** | SAP 内部非官方社区项目（实验用途） |
| **构建产物** | `jco-service/target/jco-service-1.0.0-v5.jar` |
| **官方替代** | SAP 正在开发官方 ADT MCP Server，见 [MCP Registry](https://portal.hyperspace.tools.sap/workspaces/hyperspace-mcp-registry-pilots/ai-mcp-registry/com.sap.adt%2Fmcp) |

**获取步骤：**

```bash
# 1. 克隆源码（需要 SAP 内部 GitHub 权限）
git clone https://github.wdf.sap.corp/sap-managed-tm-ewm/ai-sap-abap-adt.git
cd ai-sap-abap-adt

# 2. 构建 JAR
mvn clean package -DskipTests

# 3. 产出文件
ls jco-service/target/jco-service-1.0.0-v5.jar
```

> **参考文档：**
> - macOS 安装指南：`ai-sap-abap-adt` 仓库内 → [ClaudeCodeOnMacHowTo.md](https://github.wdf.sap.corp/sap-managed-tm-ewm/ai-modernization/blob/main/ai-foundation/ClaudeCodeOnMacHowTo.md)
> - Windows 安装指南：`ai-sap-abap-adt` 仓库内 → [ClaudeCodeOnWindowsHowTo.md](https://github.wdf.sap.corp/sap-managed-tm-ewm/ai-modernization/blob/main/ai-foundation/ClaudeCodeOnWindowsHowTo.md)

---

### 依赖 2：SAP JCo 3.1（Java Connector）

JCo 是 SAP 官方的 Java 连接库，用于 RFC 通信。**需要 S-User 账号下载。**

| 项目 | 详情 |
|------|------|
| **下载地址** | [SAP Support Portal - SAP JCo](https://support.sap.com/en/product/connectors/jco.html) |
| **当前版本** | 3.1.13（sapjco3-ntamd64-3.1.13） |
| **登录要求** | S-User 或 Universal ID |
| **许可证** | SAP 开发者许可，禁止再分发 |

**下载步骤：**

1. 登录 [SAP Support Portal](https://support.sap.com) → Tools → SAP JCo
2. 选择你的平台：
   - Windows x64: `sapjco3-ntamd64-3.1.x.zip`
   - macOS Intel: `sapjco3-darwinintel64-3.1.x.zip`
   - macOS ARM: `sapjco3-darwinarm64-3.1.x.zip`
   - Linux x64: `sapjco3-linuxx86_64-3.1.x.zip`
3. 解压后关键文件：

| 文件 | 用途 |
|------|------|
| `sapjco3.jar` | Java 接口库 |
| `sapjco3.dll` (Win) / `libsapjco3.so` (Linux) / `libsapjco3.dylib` (Mac) | 本地连接库 |

> **备选方案：** 如果你没有 S-User，找团队中有权限的同事下载后共享到内部网盘。

---

### 依赖 3：SNC 加密库（sapcrypto）

SNC（Secure Network Communication）库用于 SSO 免密码连接 SAP 系统。

| 项目 | 详情 |
|------|------|
| **来源方式 A** | 安装 [SAP Secure Login Client](https://help.sap.com/docs/SAP_SINGLE_SIGN-ON) 自动附带 |
| **默认路径 (Win)** | `C:\Program Files\SAP\FrontEnd\SecureLogin\lib\sapcrypto.dll` |
| **来源方式 B** | JCo 下载包内自带一份 `sapcrypto.dll` |
| **来源方式 C** | SAP Note 352295 - CommonCryptoLib 独立下载 |

> **注意：** 如果只使用 Basic Auth（用户名/密码）连接，可以跳过 SNC 库。
> 但 SNC 是企业网络推荐方式（无需存储密码）。

---

### 依赖汇总表

| 文件 | 放入 `lib/` 目录 | 获取方式 |
|------|-----------------|----------|
| `jco-service-1.0.0-v5.jar` | ✅ | 从源码构建 |
| `sapjco3.jar` | ✅ | SAP Support Portal 下载 |
| `sapjco3.dll` / `.so` / `.dylib` | ✅ | SAP Support Portal 下载 |
| `sapcrypto.dll` / `.so` | ✅（可选） | SAP Secure Login Client / JCo 包内 |

## Quick Start (5 minutes)

### Step 1: Clone this repo

```bash
git clone <repo-url> abap-mcp-team
cd abap-mcp-team
```

### Step 2: Set up dependencies

Create a local directory for dependencies (not committed to Git):

```bash
mkdir lib
# Copy these files into lib/:
#   - jco-service-1.0.0-v5.jar  (the MCP server)
#   - sapjco3.jar               (SAP JCo)
#   - sapjco3.dll               (SAP JCo native, Windows)
#   - libsapjco3.so             (SAP JCo native, Linux/Mac)
```

### Step 3: Configure SAP systems

```bash
cp .sap-systems.template.json .sap-systems.json
# Edit .sap-systems.json with your system details
```

### Step 4: Choose your AI tool config

Copy the appropriate config for your AI tool:

| AI Tool | Command |
|---------|---------|
| Claude Code | `claude mcp add abap-mcp --scope project ...` (see below) |
| Claude Desktop | Copy `configs/claude-desktop.json` → `%APPDATA%\Claude\claude_desktop_config.json` |
| Cursor | Copy `configs/cursor-mcp.json` → `<project>/.cursor/mcp.json` |
| Windsurf | Copy `configs/windsurf-mcp.json` → `~/.codeium/windsurf/mcp_config.json` |
| Cline | Import via Cline MCP settings UI |
| VS Code (generic) | Copy `configs/vscode-mcp.json` → `<project>/.vscode/mcp.json` |

### Step 5: Verify connection

In your AI tool, ask: "List SAP systems" — if it returns your configured systems, you're connected.

## Configuration Details

### Environment Variables

Set these before running, or configure in your shell profile:

```bash
# Required paths (adjust to your local installation)
export ABAP_MCP_JAR="/path/to/lib/jco-service-1.0.0-v5.jar"
export SAPJCO_PATH="/path/to/lib"                    # Directory containing sapjco3.dll/so
export SNC_LIB="/path/to/sapcrypto.dll"              # SNC library path

# Optional
export SAP_SYSTEMS_FILE="/path/to/.sap-systems.json" # Custom config location
```

### Windows paths example

```batch
set ABAP_MCP_JAR=C:\tools\abap-mcp\lib\jco-service-1.0.0-v5.jar
set SAPJCO_PATH=C:\tools\abap-mcp\lib
set SNC_LIB=C:\Program Files\SAP\FrontEnd\SecureLogin\lib\sapcrypto.dll
```

### Claude Code registration

```bash
claude mcp add abap-mcp --scope project -- java \
  -Djava.net.preferIPv4Stack=true \
  -Djco.middleware.snc_lib="$SNC_LIB" \
  -Dloader.path="$SAPJCO_PATH" \
  -Djava.library.path="$SAPJCO_PATH;$(dirname $SNC_LIB)" \
  -jar "$ABAP_MCP_JAR" \
  --mcp \
  --sap.adt.dangerous-operations.enabled=true
```

## SAP System Configuration

The `.sap-systems.json` file defines which SAP systems to connect to. Two authentication modes:

### SNC (recommended for corporate networks)

```json
{
  "system_id": "dev",
  "url": "https://hostname:44300",
  "client": "001",
  "snc_partnername": "p/secude:CN=SID, O=SAP-AG, C=DE",
  "snc_qop": 9,
  "description": "Development system"
}
```

### Basic Auth (for sandboxes / test systems)

```json
{
  "system_id": "sandbox",
  "url": "https://hostname:44300",
  "client": "100",
  "username": "YOUR_USER",
  "password": "YOUR_PASS",
  "description": "Sandbox system"
}
```

## Available Tools (120 total)

The server exposes 120 MCP tools covering the full ABAP development lifecycle:

| Category | Count | Examples |
|----------|-------|---------|
| Read source code | 30+ | GetClass, GetCDSView, GetTable, GetInterface |
| Create objects | 16 | CreateClass, CreateDDLSource, CreateTable |
| Save/modify objects | 18 | SaveClass, SaveDDLSource, SaveProgram |
| Delete objects | 13 | DeleteClass, DeleteCDSView |
| Debugging | 10 | DebugStartSession, DebugStep, DebugGetVariables |
| Unit testing | 2 | RunAbapUnit, RunATC |
| ATC quality | 5 | GetATCFindings, ListATCResults |
| Version control | 3 | GetVersionHistory, CompareVersions |
| Transport requests | 4 | ListTransportRequests, GetTransportContents |
| Session management | 3 | CreateSession, DestroySession |
| Search & analysis | 4 | Search, GetWhereUsed, GetPackageContents |
| Data preview | 3 | PreviewTableData, PreviewCDSView, SelectSQLQuery |
| System config | 5 | AddSystem, ListSystems |
| Utilities | 4 | FormatADTResponse, ActivateObject, CheckSyntax |

See `docs/tools-reference.md` for full parameter documentation.

## Troubleshooting

### "JCo library not found"

Ensure `sapjco3.dll` (Windows) or `libsapjco3.so` (Linux) is in the path specified by `-Djava.library.path`.

### "SNC handshake failed"

- Verify SAP Secure Login Client is installed
- Check `SNC_LIB` points to the correct `sapcrypto.dll`
- Ensure your SSO ticket is valid (re-login to SAP GUI if needed)

### "Connection refused"

- Verify the SAP system URL and port in `.sap-systems.json`
- Check network/VPN connectivity to the SAP host
- Ensure ADT services are enabled on the SAP system (transaction SICF → `/sap/bc/adt`)

### Server starts but no tools appear

- Check Java version: `java -version` (must be 17+)
- Verify JAR path is correct and file exists
- Check AI tool's MCP log for error messages

## Security Notes

- **Never commit** `.sap-systems.json` — it may contain credentials
- **Never commit** `lib/` directory — contains licensed SAP binaries
- Use SNC authentication where possible (no passwords stored)
- The `.gitignore` in this repo protects against accidental commits

---

# 方案 B：REST 版（轻量版 - 外部可用）

> 适用于外部客户、合作伙伴、开源社区。无需 SAP 内部权限，MIT 许可证。

## 概述

REST 版基于 [mario-andreschak/mcp-abap-adt](https://github.com/mario-andreschak/mcp-abap-adt) 开源项目，通过 ADT REST API 与 SAP 系统通信，不依赖 JCo。

**本仓库已将 MCP Server 源码作为 git submodule 包含在 `server/` 目录中，克隆后即可构建使用。**

| 项目 | 详情 |
|------|------|
| **源码 (submodule)** | `server/` → [github.com/mario-andreschak/mcp-abap-adt](https://github.com/mario-andreschak/mcp-abap-adt) |
| **许可证** | MIT |
| **技术栈** | TypeScript / Node.js |
| **VS Code 扩展** | VS Code Marketplace 搜索 "ABAP MCP" (publisher: HariePrasad) |
| **平台** | Windows / macOS / Linux（从源码运行） |

## Prerequisites（REST 版）

| Dependency | Source | Notes |
|-----------|--------|-------|
| SAP 系统账号 | 你的 SAP 管理员 | 需要 ADT 权限 |
| 网络连接 | VPN / 直连 | 能访问 SAP 系统 HTTPS 端口 |
| VS Code (可选) | https://code.visualstudio.com | 如果用扩展方式安装 |

**不需要：** Java、JCo、SNC 库、S-User 账号、SAP 内部 GitHub 权限

## 安装方式

### 方式 1：VS Code 扩展（最简单）

```bash
# 在 VS Code 中搜索安装
ext install HariePrasad.abap-mcp
```

安装后：
1. 打开任意工作区文件夹
2. 扩展自动部署 `.vscode/mcp.json` 配置
3. 编辑 `env` 部分填入 SAP 凭据
4. 重新加载 VS Code → 即可使用

### 方式 2：从本仓库 submodule 构建（推荐，一站式）

```bash
# 1. 克隆本仓库（含 submodule）
git clone --recurse-submodules https://github.com/senyLiang/abap-mcp.git
cd abap-mcp

# 2. 进入 server 目录，安装依赖
cd server
npm install

# 3. 构建
npm run build

# 4. 运行 MCP Server
node dist/index.js
```

> 如果克隆时忘记加 `--recurse-submodules`，补救：
> ```bash
> git submodule init
> git submodule update
> ```

### 方式 3：独立克隆上游源码

```bash
# 1. 直接克隆上游项目
git clone https://github.com/mario-andreschak/mcp-abap-adt.git
cd mcp-abap-adt

# 2. 安装依赖
npm install

# 3. 构建
npm run build

# 4. 运行
node dist/index.js
```

### 方式 3：直接使用 exe（从扩展提取）

VS Code 扩展安装后，exe 位于：
```
%USERPROFILE%\.vscode\extensions\harieprasad.abap-mcp-<version>\bin\abap-mcp.exe
```

## REST 版配置（各 AI 工具）

### Claude Desktop / Cursor / Windsurf / Cline

```json
{
  "mcpServers": {
    "abap-mcp": {
      "type": "stdio",
      "command": "/path/to/abap-mcp.exe",
      "args": [],
      "env": {
        "SAP_URL": "https://your-sap-host:44300",
        "SAP_USERNAME": "your_username",
        "SAP_PASSWORD": "your_password",
        "SAP_CLIENT": "100",
        "SAP_LANGUAGE": "en",
        "TLS_REJECT_UNAUTHORIZED": "0"
      }
    }
  }
}
```

### Claude Code

```bash
claude mcp add abap-mcp --scope project \
  -e SAP_URL=https://your-sap-host:44300 \
  -e SAP_USERNAME=your_username \
  -e SAP_PASSWORD=your_password \
  -e SAP_CLIENT=100 \
  -e SAP_LANGUAGE=en \
  -e TLS_REJECT_UNAUTHORIZED=0 \
  -- /path/to/abap-mcp.exe
```

### 代理设置（企业网络）

如需通过代理访问 SAP 系统：

```json
{
  "env": {
    "HTTP_PROXY": "http://username:password@proxy-host:port",
    "HTTPS_PROXY": "http://username:password@proxy-host:port"
  }
}
```

## REST 版工具列表

REST 版提供的核心工具：

| 类别 | 工具 |
|------|------|
| 搜索 | SearchObject |
| 读取 | GetObjectInfo (支持 18 种对象类型) |
| 依赖分析 | WhereUsedSearch |
| 数据查询 | data_preview (SELECT) |
| 创建对象 | CreateAIObject |
| 修改对象 | ChangeAIObject |
| 激活 | ActivateObject |
| SAP 帮助 | sap_help_search, sap_help_get |
| 社区搜索 | sap_community_search |

## REST 版 vs JCo 版功能差异

| 功能 | JCo 版 | REST 版 |
|------|--------|---------|
| 读取所有对象源码 | ✅ | ✅ |
| 搜索对象 | ✅ | ✅ |
| Where-Used 分析 | ✅ | ✅ |
| 数据预览 / SQL | ✅ | ✅ |
| 创建对象 | ✅ | ✅ |
| 修改对象 | ✅ | ✅ |
| 激活对象 | ✅ | ✅ |
| SAP 帮助搜索 | ✅ | ✅ |
| 调试 (breakpoints/step) | ✅ | ❌ |
| 版本对比 | ✅ | ❌ |
| 代码覆盖率 | ✅ | ❌ |
| ATC 静态检查 | ✅ | ❌ |
| ABAP Unit 测试 | ✅ | ❌ |
| 传输请求管理 | ✅ | ❌ |
| SNC/SSO 认证 | ✅ | ❌ |
| 运行时错误 (ST22) | ✅ | ❌ |
| 多系统切换 | ✅ (7+系统) | ❌ (单系统) |

## Troubleshooting（REST 版）

### "TLS certificate error"

设置环境变量：
```json
"TLS_REJECT_UNAUTHORIZED": "0"
```
> 仅用于测试环境。生产环境应配置正确的 CA 证书。

### "401 Unauthorized"

- 检查用户名/密码是否正确
- 确认用户在该 Client 有 ADT 授权（角色 `SAP_BC_DWB_ABAPDEVELOPER`）
- 确认 SAP 系统 SICF 中 `/sap/bc/adt` 节点已激活

### "Connection timeout"

- 检查 VPN 是否连接
- 确认 SAP 系统 URL 和端口正确
- 如果在企业网络，配置 `HTTP_PROXY` / `HTTPS_PROXY`

---

# 如何选择？

```
你是 SAP 内部员工？
├── 是 → 用 JCo 版（方案 A）→ 全功能 120 工具
└── 否 → 你是 SAP 客户/合作伙伴？
    ├── 是 → 用 REST 版（方案 B）→ 核心功能已够用
    └── 否 → 用 REST 版 + 公开 SAP 试用系统
              (SAP BTP Trial: https://developers.sap.com)
```

---

# 外部用户完整使用流程（VS Code + REST 版）

> 以下流程面向非 SAP 内部人员，从零开始到成功使用 ABAP MCP Server。

## 前提条件确认

| # | 条件 | 如何获取 |
|---|------|----------|
| 1 | Node.js 18+ | https://nodejs.org 下载安装，终端运行 `node -v` 验证 |
| 2 | Git | https://git-scm.com 下载安装 |
| 3 | VS Code | https://code.visualstudio.com 下载安装 |
| 4 | AI 扩展 | VS Code 中安装 GitHub Copilot 或 Claude Code 扩展 |
| 5 | SAP 系统账号 | 找你的 SAP 管理员获取（用户名、密码、Client） |
| 6 | SAP 系统 URL | 格式：`https://主机名:端口`（如 `https://sap.company.com:44300`） |
| 7 | 网络连通 | 确保能访问 SAP 系统（VPN / 直连） |

## Step 1：克隆仓库

```bash
git clone --recurse-submodules https://github.com/senyLiang/abap-mcp.git
cd abap-mcp
```

> 如果忘记加 `--recurse-submodules`：
> ```bash
> cd abap-mcp
> git submodule init
> git submodule update
> ```

## Step 2：构建 MCP Server

```bash
cd server
npm install
npm run build
```

构建成功后会生成 `server/dist/index.js`，这就是 MCP Server 的入口文件。

验证构建成功：
```bash
node dist/index.js --help
# 或者看 dist/ 目录是否生成了 .js 文件
ls dist/
```

## Step 3：配置 VS Code MCP

回到仓库根目录，在你的**工作项目**中创建 `.vscode/mcp.json`：

```bash
cd ..  # 回到 abap-mcp 根目录
```

在你要进行 ABAP 开发的 VS Code 工作区中，创建 `.vscode/mcp.json`：

```json
{
  "servers": {
    "abap-mcp": {
      "type": "stdio",
      "command": "node",
      "args": ["C:/path/to/abap-mcp/server/dist/index.js"],
      "env": {
        "SAP_URL": "https://your-sap-host:44300",
        "SAP_USERNAME": "your_username",
        "SAP_PASSWORD": "your_password",
        "SAP_CLIENT": "100",
        "SAP_LANGUAGE": "en",
        "TLS_REJECT_UNAUTHORIZED": "0"
      }
    }
  }
}
```

**替换说明：**

| 占位符 | 替换为 | 示例 |
|--------|--------|------|
| `C:/path/to/abap-mcp/server/dist/index.js` | server 构建产物的绝对路径 | `C:/Users/john/abap-mcp/server/dist/index.js` |
| `your-sap-host:44300` | SAP 系统地址和端口 | `sap-dev.company.com:44300` |
| `your_username` | SAP 对话用户 | `DEVELOPER01` |
| `your_password` | SAP 密码 | `xxxxxxxx` |
| `100` | SAP Client 编号 | `001`、`100`、`800` 等 |

## Step 4：重新加载 VS Code

按 `Ctrl+Shift+P` → 输入 `Reload Window` → 回车

VS Code 会启动 MCP Server 并连接到你的 SAP 系统。

## Step 5：验证连接

### 使用 GitHub Copilot

打开 Copilot Chat，输入：
```
@workspace 使用 MCP 工具搜索 SAP 系统中所有以 Z 开头的类
```

### 使用 Claude Code

在 Claude Code 终端中输入：
```
搜索 SAP 系统中所有以 Z 开头的程序
```

如果返回对象列表 → **连接成功！**

## Step 6：开始开发

连接成功后，你可以通过 AI 助手执行以下操作：

```
# 查看类源码
"读取类 ZCL_MY_CLASS 的源码"

# 搜索对象
"搜索所有以 ZFI 开头的 CDS 视图"

# 查看表结构
"显示表 SFLIGHT 的字段定义"

# 查询数据
"从表 SCARR 中查询所有航空公司"

# 分析依赖
"ZCL_MY_CLASS 在哪里被使用了"

# 创建对象（$TMP 包）
"在 $TMP 包中创建一个新的 ABAP 类 ZCL_TEST"

# 查找帮助
"搜索 SAP 帮助：ABAP RAP behavior definition"
```

---

## 常见问题 FAQ

### Q: 我没有 SAP 系统怎么办？

可以申请 SAP BTP Trial（免费）：
1. 访问 https://developers.sap.com
2. 注册账号 → 申请 BTP Trial
3. 在 BTP 中创建 ABAP Environment 实例
4. 获取系统 URL 和凭据

### Q: 支持哪些 SAP 系统？

任何启用了 ADT 服务的 SAP 系统：
- SAP S/4HANA (On-Premise)
- SAP S/4HANA Cloud, private edition
- SAP BTP, ABAP Environment (Steampunk)
- SAP NetWeaver 7.50+（需启用 ADT）

### Q: MCP Server 启动后什么反应都没有？

这是正常的。MCP Server 使用 stdio 通信，不会在终端显示输出。它等待 AI 工具通过 stdin 发送请求。验证方法是通过 AI 助手发送命令。

### Q: 可以同时连接多个 SAP 系统吗？

REST 版一次连接一个系统。如需切换，修改 `.vscode/mcp.json` 中的环境变量后重新加载 VS Code。JCo 版支持多系统同时连接。

### Q: 代理怎么配？

在 `env` 中添加：
```json
"HTTP_PROXY": "http://user:pass@proxy.company.com:8080",
"HTTPS_PROXY": "http://user:pass@proxy.company.com:8080"
```

### Q: macOS / Linux 能用吗？

可以。从源码构建（`npm install && npm run build`）后用 `node dist/index.js` 运行，不依赖 Windows 特定组件。
