SHELL := /bin/bash

ci:
	pipenv install
	##make test-legacy  # dev/debug
	make test

DL_ASSETS := https://github.com/research-coders-cs/transduction/releases/download/assets-0.1
Dataset_train_test_val:
	curl -O -L $(DL_ASSETS)/$@.rar
	unrar x $@.rar
net_debug.pth:
	curl -O -L $(DL_ASSETS)/$@
test-legacy: Dataset_train_test_val net_debug.pth
	rm -rf log_legacy.txt result_legacy && mkdir result_legacy
	pipenv run python3 main_legacy.py 2>&1 | tee log_legacy.txt
	zip -r result_legacy.zip result_legacy > /dev/null

#

spacy-dl:
	pipenv run python3 -m spacy download de_core_news_sm
	pipenv run python3 -m spacy download en_core_web_sm
test:
	pipenv run python3 -m pip install --force-reinstall .  # for `import transduction` to work
	make run
run:
	rm -rf log.txt output && mkdir output
	time pipenv run python3 main.py 2>&1 | tee log.txt
