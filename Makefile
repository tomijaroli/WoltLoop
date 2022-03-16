install:
	@git config core.hooksPath .githooks
	@brew config && brew update
	@brew bundle