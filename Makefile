# AUTOGEN model pkg

PACKAGE=model
WARNING=// THIS FILE IS AUTO-GENERATED. DO NOT TOUCH !!\n
SQL2GO=$(GOPATH)/src/ds3g/orm/utils/sql2go

define logo
\n\
.\n\
.    _  ___    \n\
.   | \(_ _) _  \n\
.   |_/__)_)(_| \n\
.            _| \n\n\n
endef


all : logo schema_sql.autogen.go\
   	dbobjects.autogen.go\
   	iso_lang_codes.autogen.go

logo:
	@echo "$(logo)"


# order is paramount!
schema_sql.autogen.go : sql/schema.sql
	cat $< |\
		awk '\
		BEGIN { \
			print "$(WARNING)" ; \
			print "package $(PACKAGE)\n\n" ; \
			print "func schemaSQL() string {\nreturn `" } \
		{print} \
		END { \
			print "`\n}" } ' |\
		gofmt > $@

iso_lang_codes.autogen.go : sql/iso_lang_codes.csv
	cat $< |\
		awk '\
		BEGIN { \
			print "$(WARNING)" ; \
			print "package $(PACKAGE)\n\n" ; \
			print "func isoLangCodesSQL() string {\nreturn `" } \
		/^[^#].+$$/ { \
			print "INSERT INTO lang_codes values(\"" $$1 "\",\"" $$2 "\");" } \
		END { \
			print "`\n}" } ' |\
		gofmt > $@

#	sql2go
dbobjects.autogen.go : sql/schema.sql
	$(SQL2GO) $(PACKAGE) < $^ > $@

clean :
	-rm *.autogen.go


