import time

from django.db import connections
from django.db.utils import OperationalError
from django.core.management.base import BaseCommand

from psycopg2 import OperationalError as Psycopg2OperationalError

class Command(BaseCommand):
    
    def handle(self, *args, **options):
        self.stdout.write('Waiting for DB')
        db_con = None
        while not db_con:
            try:
                db_con = connections['default']
            except (OperationalError, Psycopg2OperationalError):
                self.stdout.write('DB unavailable, waiting 1 second')
                time.sleep(1)
        self.stdout.write(self.style.SUCCESS('DB available!'))
