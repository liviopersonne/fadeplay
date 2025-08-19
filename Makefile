run:
	flutter run
generate-db:
	dart run build_runner build --delete-conflicting-outputs  
generate-db-continuous:
	dart run build_runner watch --delete-conflicting-outputs  
open-db:
	sqlitebrowser lib/desktop/db/fadeplay.sqlite
reset-db:
	rm lib/desktop/db/fadeplay.sqlite