from flask import Flask, render_template, request
from sqlalchemy import create_engine, func
from sqlalchemy.orm import sessionmaker, joinedload
from repo_setup import Game, PriceData  # Reutilizamos los modelos
# Reutilizamos la configuración de DB (aunque importarlas no es necesario aquí, es bueno para la consistencia)
from scraper_multicore import DB_NAME, ENGINE, SessionLocal 

app = Flask(__name__)

def get_best_deals(session):
    """
    Consulta la base de datos y calcula la mejor oferta (precio más bajo)
    para cada juego entre Steam y Amazon.
    """
    games = session.query(Game).all()
    
    final_data = []
    for game in games:
        prices = session.query(PriceData).filter(PriceData.game_id == game.id).all()
        
        best_deal = {
            'price': float('inf'),
            'discount': 0,
            'store': 'N/A',
            'platform': 'N/A'
        }
        
        for price in prices:
            if price.current_price is not None and price.current_price < best_deal['price']:
                best_deal['price'] = price.current_price
                best_deal['discount'] = price.discount_percentage
                best_deal['store'] = price.store_name
                best_deal['platform'] = price.platform

        game_data = {
            'title': game.title,
            'cover_image_url': game.cover_image_url,  # Portada añadida
            'release_date': game.release_date,
            'genres': game.genres,
            'steam_rating': game.steam_rating,
            'reference_price': game.reference_price,
            'best_price': best_deal['price'] if best_deal['price'] != float('inf') else game.reference_price,
            'best_discount': best_deal['discount'],
            'best_store': best_deal['store'],
            'best_platform': best_deal['platform']
        }
        final_data.append(game_data)
        
    return final_data

@app.route('/')
def index():
    session = SessionLocal()
    
    sort_by = request.args.get('sort', 'title')  # Orden por defecto: título
    order = request.args.get('order', 'asc')     # Orden por defecto: ascendente

    data = get_best_deals(session)
    session.close()

    reverse_order = (order == 'desc')
    
    if sort_by == 'price':
        data.sort(key=lambda x: x['best_price'], reverse=reverse_order)
    elif sort_by == 'discount':
        data.sort(key=lambda x: x['best_discount'], reverse=reverse_order)
    elif sort_by == 'rating':
        data.sort(key=lambda x: x['steam_rating'] if x['steam_rating'] is not None else -1, reverse=reverse_order)
    else:  # Por defecto 'title'
        data.sort(key=lambda x: x['title'], reverse=reverse_order)

    return render_template('index.html', games=data, current_sort=sort_by, current_order=order)


if __name__ == '__main__':
    # Se necesita que scraper_multicore.py haya corrido al menos una vez
    app.run(debug=True)
