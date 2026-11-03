import os
from django.core.wsgi import get_wsgi_application

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings')

application = get_wsgi_application()

# Vercel Serverless Function entry point
app = application

# Auto-migrate and seed on Vercel deployment if running in serverless environment
if os.environ.get('VERCEL'):
    try:
        from django.core.management import call_command
        call_command('migrate', interactive=False)
        call_command('seed_data')
    except Exception as e:
        print(f"Vercel auto-seed status: {e}")
