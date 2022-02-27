brew.install-all:
	cat brew-list | xargs -n 1 -I %% "brew install %%"
