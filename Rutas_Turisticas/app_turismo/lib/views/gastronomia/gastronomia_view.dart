import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class GastronomiaView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: ListView(
        children: [
          Text(
            'Gastronomía Local',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          
          // Platos típicos
          _buildCategorySection(
            context: context,
            title: 'Platos Típicos',
            dishes: [
              GastronomyItem(
                name: 'Locro de Papa',
                description: 'Sopa cremosa de papas con queso, aguacate y ají.',
                imageUrl: 'https://i.imgur.com/L12vn59.jpg',
                price: '\$5.50 - \$8.00',
                places: [
                  Place(
                    name: 'Restaurante La Ronda', 
                    mapUrl: 'https://maps.app.goo.gl/hC6APW1CFM9c4Ufd9'
                  ),
                  Place(
                    name: 'El Café de la Vaca', 
                    mapUrl: 'https://maps.app.goo.gl/sUTaLx1S9P2Tyioc7'
                  ),
                ]
              ),
              GastronomyItem(
                name: 'Fritada',
                description: 'Carne de cerdo frita acompañada de maíz, plátano y aguacate.',
                imageUrl: 'https://i.imgur.com/2DEVr6b.jpg',
                price: '\$7.00 - \$12.00',
                places: [
                  Place(
                    name: 'Vista Hermosa', 
                    mapUrl: 'https://maps.app.goo.gl/TWt5e3PUdvcGx4v19'
                  ),
                  Place(
                    name: 'Lo Nuestro', 
                    mapUrl: 'https://maps.app.goo.gl/HTnuGk7F4pzPtaTZ6'
                  ),
                ]
              ),
            ],
          ),
          
          SizedBox(height: 24),
          
          // Postres y dulces
          _buildCategorySection(
            context: context,
            title: 'Postres y Dulces',
            dishes: [
              GastronomyItem(
                name: 'Espumillas',
                description: 'Postre tradicional elaborado con claras de huevo y azúcar.',
                imageUrl: 'https://i.imgur.com/yx1GpEA.jpg',
                price: '\$1.50 - \$2.00',
                places: [
                  Place(
                    name: 'Mercado Central', 
                    mapUrl: 'https://maps.app.goo.gl/2aLUGbssBa3GXzNL8'
                  ),
                ]
              ),
              GastronomyItem(
                name: 'Quesadillas',
                description: 'Pastelillos dulces hechos con queso fresco y harina.',
                imageUrl: 'https://i.imgur.com/C3zShKv.jpg',
                price: '\$0.80 - \$1.20',
                places: [
                  Place(
                    name: 'Panadería La Vienesa', 
                    mapUrl: 'https://maps.app.goo.gl/RsEKvRcJBPCSDgfx7'
                  ),
                ]
              ),
            ],
          ),
          
          SizedBox(height: 24),
          
          // Bebidas típicas
          _buildCategorySection(
            context: context,
            title: 'Bebidas Típicas',
            dishes: [
              GastronomyItem(
                name: 'Canelazo',
                description: 'Bebida caliente a base de naranjilla, canela y aguardiente.',
                imageUrl: 'https://i.imgur.com/JFP0YiE.jpg',
                price: '\$2.00 - \$3.50',
                places: [
                  Place(
                    name: 'La Ronda', 
                    mapUrl: 'https://maps.app.goo.gl/hC6APW1CFM9c4Ufd9'
                  ),
                ]
              ),
              GastronomyItem(
                name: 'Chicha',
                description: 'Bebida fermentada de maíz o frutas, tradicional de los Andes.',
                imageUrl: 'https://i.imgur.com/TLBwbcC.jpg',
                price: '\$1.50 - \$2.50',
                places: [
                  Place(
                    name: 'Mercado de Artesanías', 
                    mapUrl: 'https://maps.app.goo.gl/W2xJQ4CKvQXMwMqJ7'
                  ),
                ]
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection({
    required BuildContext context,
    required String title,
    required List<GastronomyItem> dishes,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.teal.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 12),
        ...dishes.map((dish) => _buildDishCard(context, dish)).toList(),
      ],
    );
  }

  Widget _buildDishCard(BuildContext context, GastronomyItem dish) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen del plato
          Image.network(
            dish.imageUrl,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 180,
                color: Colors.grey[300],
                child: Center(child: Icon(Icons.image, size: 50)),
              );
            },
          ),
          
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nombre y precio
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        dish.name,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        dish.price,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 8),
                
                // Descripción
                Text(dish.description),
                
                SizedBox(height: 12),
                
                // Dónde encontrar
                Text(
                  'Dónde encontrar:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                
                ...dish.places.map((place) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.restaurant, color: Colors.red),
                  title: Text(place.name),
                  trailing: IconButton(
                    icon: Icon(Icons.map, color: Colors.blue),
                    onPressed: () async {
                      final Uri url = Uri.parse(place.mapUrl);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('No se pudo abrir el mapa')),
                        );
                      }
                    },
                  ),
                )).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GastronomyItem {
  final String name;
  final String description;
  final String imageUrl;
  final String price;
  final List<Place> places;

  GastronomyItem({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.places,
  });
}

class Place {
  final String name;
  final String mapUrl;

  Place({required this.name, required this.mapUrl});
}
