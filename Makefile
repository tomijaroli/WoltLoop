install:
	@git config core.hooksPath .githooks
	@brew config && brew update
	@brew bundle

setup:
	@echo "All set now!"

publish-development:
	@echo "Haha you got bamboozled! Publishing is not implemented yet, come back later!"

publish-release:
	@echo "Haha you got bamboozled! Publishing is not implemented yet, come back later!"