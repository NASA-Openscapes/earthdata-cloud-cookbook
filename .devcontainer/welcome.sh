mkdir -p ~/.local/share/rstudio/projects_settings
export RPROJ"=$(ls ${CODESPACE_VSCODE_FOLDER}/*.Rproj)"
echo ${RPROJ} > ~/.local/share/rstudio/projects_settings/last-project-path


# Construct the message
message="## [Open in RStudio](https://$CODESPACE_NAME-8787.app.github.dev)
"
# Echo the message to the terminal
echo "
👋 Welcome to Codespaces! You are on our custom image. 
   - It includes runtimes and tools for Python & R using Jupyter, Quarto, or RStudio 

🌐 Open the RStudio editor here: https://$CODESPACE_NAME-8787.app.github.dev
   - (This may take a few seconds to load, retry if necessary)
"
