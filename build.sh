# To build the plugin and place it in your Studio plugins folder
# Run sh build.sh in your terminal
mkdir build
rojo build place.project.json --output build/hoarcekat-dev.rbxl
rojo build plugin.project.json --plugin hoarcekat.rbxm