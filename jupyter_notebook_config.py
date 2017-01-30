from jupyter_core.paths import jupyter_data_dir

c = get_config()
c.NotebookApp.ip = '*'
c.NotebookApp.port = 8888
c.NotebookApp.open_browser = False
c.NotebookApp.server_extensions.append(
    'jade_utils.notebook_extentions'
)
