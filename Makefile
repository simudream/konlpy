# Deployment instructions
# 0. Fill in `pypirc.sample`, and `cp pypirc.sample ~/.pypirc`
# 1. Check changelogs.rst
# 2. Check translations at docs/locale/ko/LC_MESSAGES/*.po
# 3. Check version at konlpy/__init__.py
# 4. $ make testpypi
# 5. $ make pypi # Beware not to change the version number at this stage!!!
# 6. Document update at RTD (latest)
# 7. Push tag
# 8. Document update at RTD (current version)
#

check:
	check-manifest
	pyroma dist/konlpy-*tar.gz

testpypi:
	sudo python setup.py register -r pypitest
	sudo python setup.py sdist --formats=gztar,zip upload -r pypitest
	sudo python setup.py bdist_wheel upload -r pypitest
	# Execute below manually
	# 	cd /tmp
	# 	virtualenv venv
	# 	source venv/bin/activate
	# 	pip install -i https://testpypi.python.org/pypi konlpy
	# 	deactivate
	# 	virtualenv-3.4 venv3
	# 	source venv3/bin/activate
	# 	pip3 install -i https://testpypi.python.org/pypi konlpy
	# 	deactivate

pypi:
	sudo python setup.py register -r pypi
	sudo python setup.py sdist --formats=gztar,zip upload -r pypi
	sudo python setup.py bdist_wheel upload -r pypi

jcc:
	python -m jcc \
	    --jar konlpy/java/jhannanum-0.8.4.jar \
	    --classpath konlpy/java/bin/kr/lucypark/jhannanum \
	    --python pyhannanum \
	    --version 0.1.0 \
	    --build --install

testall:
	python -m pytest test/*
	python3 -m pytest test/*

init_i18n:
	pip install mock sphinx sphinx-intl
	git submodule init
	git submodule update

extract_i18n:
	cd docs\
	    && make gettext\
	    && sphinx-intl update -p _build/locale -l ko

update_i18n:
	cd docs\
	    && sphinx-intl build\
	    && make -e SPHINXOPTS="-D language='ko'" html
