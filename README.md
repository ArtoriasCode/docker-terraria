## 🛠 Terraria dedicated server in Docker
A simple and configurable Docker setup for hosting a dedicated **vanilla** Terraria server.
- ⚙️ Fully configurable via `.env` and `serverconfig.txt`
- 💾 Automatic start via `screen` for auto-saves
- 🗺️ The ability to generate worlds and upload your own
- 🚀 Simple and fast deployment using Docker Compose
- 🔁 Automatic startup after VPS startup / restart

## 📥 Project download
> [!NOTE]
> To download the project on your VPS server, follow the instructions below.

1) Install `git`:
```
sudo apt update
```
```
sudo apt install git
```
2) Download the repository:
```
git clone https://github.com/ArtoriasCode/docker-terraria.git
```

## ⚙️ Server configuration
> [!NOTE]
> To create the necessary files for the Terraria server and configure it according to your preferences, follow the instructions below.

1) Navigate to the project directory:
```
cd docker-terraria
```
2) Create a `.env` file:
```
cp .env.example .env
```
3) Install the package for editing files:
```
sudo apt install nano
```
4) Open the `.env` file for editing:
```
nano .env
```
5) Specify the desired version of Terraria **(without dots)**.
6) Save the file by pressing `Ctrl + O`, then close the file by pressing `Ctrl + X`.
7) Open the `serverconfig.txt` file for editing:
```
nano data/serverconfig.txt
```
8) Specify the desired settings such as password, world name, number of players, etc.
9) Save the file by pressing `Ctrl + O`, then close the file by pressing `Ctrl + X`.

## 🌍 Custom world
> [!NOTE]
> If you want to install your own pre-generated world on the server, follow the instructions below.

1) Create a directory with Terraria worlds in the project root directory:
```
mkdir -p Terraria/Worlds
```
2) Upload your world files (`.wld`, `.bak`, etc.) to it:
```
scp path_to_file server_user@server_id:/path_to_project/Terraria/Worlds
```
> [!TIP]
> Example: `scp /home/artorias/myworld.wld root@127.0.0.1:/root/docker-terraria/Terraria/Worlds`

3) Change the name of the world in `serverconfig.txt` in the `world` field.

## 🔨 Installation
> [!NOTE]
> To start the automatic installation of the Terraria server in Docker, follow the instructions below.

1) Grant execution rights to the installation script:
```
chmod +x scripts/install.sh
```
2) Run the installation script:
```
./scripts/install.sh
```
3) Wait until the installation is complete.

To access the server in the game, enter the IP address of your VPS server, the port specified in `.env`, and the password specified in `serverconfig.txt`, if specified.
