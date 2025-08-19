run:
	flutter run
db-generate:
	dart run build_runner build --delete-conflicting-outputs  
db-generate-continuous:
	dart run build_runner watch --delete-conflicting-outputs  
open-db:
	sqlitebrowser lib/desktop/db/fadeplay.sqlite
reset-db:
	rm lib/desktop/db/fadeplay.sqlite