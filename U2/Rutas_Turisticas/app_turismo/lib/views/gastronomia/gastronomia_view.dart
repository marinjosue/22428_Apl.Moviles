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
            'Gastronomía Local: Sangolquí - Quito',
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
                name: 'Hornado',
                description: 'Cerdo horneado a leña con mote y agrio, especialidad de Sangolquí.',
                imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS1-0kNIhAWd2LVyovV9kdAEHlJF2-3e7TG3w&s',
                price: '\$5.00 - \$8.00',
                places: [
                  Place(
                    name: 'Hornados Dieguito (Sangolquí)',
                    latitude: -0.3309621,
                    longitude: -78.4464286,
                    address: 'Av. Gral. Enríquez, Sangolquí'
                  ),
                  Place(
                    name: 'Mercado Turismo (Sangolquí)', 
                    latitude: -0.3302492,
                    longitude: -78.4464923,
                    address: 'Sangolquí 171103'
                  ),
                ]
              ),
              GastronomyItem(
                name: 'Fritada',
                description: 'Carne de cerdo frita acompañada de maíz, plátano y aguacate.',
                imageUrl: 'https://www.recetasnestle.com.ec/sites/default/files/styles/recipe_detail_mobile/public/srh_recipes/e5cb8814a143a1043c9930b8a57ddab3.jpg?itok=iuxzd8rB',
                price: '\$7.00 - \$12.00',
                places: [
                  Place(
                    name: 'Fritadas Amazonas (El Tingo)', 
                    latitude: -0.2902799,
                    longitude: -78.4264695,
                    address: 'Vía Intervalles, El Tingo'
                  ),
                  Place(
                    name: 'El Palacio de la Fritada (Quito)', 
                    latitude: -0.2067861,
                    longitude: -78.4903273,
                    address: 'Jorge Washington, Quito 170109'
                  ),
                ]
              ),
              GastronomyItem(
                name: 'Yaguarlocro',
                description: 'Sopa tradicional ecuatoriana con sangre de borrego, papas y aguacate.',
                imageUrl: 'https://www.recetasnestle.com.ec/sites/default/files/srh_recipes/cf1fa44fbf8d9aafdba757700dfd5678.jpg',
                price: '\$6.50 - \$9.50',
                places: [
                  Place(
                    name: 'Picantería Dieguito (Sangolquí)', 
                    mapUrl: 'https://maps.app.goo.gl/sRgoxo4Bs3MTrmuF8',
                    address: 'Av. Luis Cordero & Quito, Sangolquí'
                  ),
                  Place(
                    name: 'La Choza (Quito)', 
                    mapUrl: 'https://maps.app.goo.gl/1fVE8YFCVUCBvgUP7',
                    address: '12 de Octubre N24-551, Quito 170143'
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
                name: 'Helados de Paila',
                description: 'Helados artesanales preparados en paila de bronce.',
                imageUrl: 'https://www.cocina-ecuatoriana.com/base/stock/Recipe/helado-de-paila/helado-de-paila_web.jpg',
                price: '\$1.50 - \$3.00',
                places: [
                  Place(
                    name: 'Helados de Paila San Sebastián (Sangolquí)', 
                    mapUrl: 'https://maps.app.goo.gl/QBmW4w5RjP7w8G9HA',
                    address: 'Centro Comercial San Luis Shopping, Sangolquí'
                  ),
                  Place(
                    name: 'Heladería San Agustín (Quito)', 
                    mapUrl: 'https://maps.app.goo.gl/ADPcoJGECrNwjE786',
                    address: 'Venezuela Oe2-94, Quito 170401'
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
                imageUrl: 'https://media.elcomercio.com/wp-content/uploads/2024/12/canelazo.jpg',
                price: '\$2.00 - \$3.50',
                places: [
                  Place(
                    name: 'La Ronda (Quito)', 
                    mapUrl: 'https://maps.app.goo.gl/q32T5HtfNBbxnq5t8',
                    address: 'Calle la Ronda, Quito 170401'
                  ),
                  Place(
                    name: 'Café del Fraile (Quito)', 
                    mapUrl: 'https://maps.app.goo.gl/DG61Fx5QGXcVMDVLA',
                    address: 'Calle Morales Oe3-49, Quito 170401'
                  ),
                ]
              ),
              GastronomyItem(
                name: 'Chicha de Jora',
                description: 'Bebida fermentada de maíz, tradicional de los Andes.',
                imageUrl: 'https://cloudfront-us-east-1.images.arcpublishing.com/infobae/AY4ONWSJBNGRPPIF7GYZ6AODBE.jpg',
                price: '\$1.50 - \$2.50',
                places: [
                  Place(
                    name: 'Mercado Central de Sangolquí', 
                    mapUrl: 'https://maps.app.goo.gl/X9ZS1dyraDrFdGLb9',
                    address: 'Juan Montalvo, Sangolquí'
                  ),
                  Place(
                    name: 'Mercado de San Roque (Quito)', 
                    mapUrl: 'https://maps.app.goo.gl/MmiN5E1qvLeGsPwh7',
                    address: 'Av. Mariscal Sucre, Quito 170129'
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
                
                ...dish.places.map((place) => Card(
                  elevation: 1,
                  margin: EdgeInsets.symmetric(vertical: 4),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(Icons.restaurant, color: Colors.red),
                          title: Text(place.name),
                          subtitle: Text(place.address),
                          trailing: IconButton(
                            icon: Icon(Icons.map, color: Colors.blue),
                            onPressed: () {
                              _launchGoogleMaps(context, place);
                            },
                          ),
                        ),
                        SizedBox(height: 4),
                        TextButton.icon(
                          icon: Icon(Icons.directions, color: Colors.green),
                          label: Text('Obtener indicaciones'),
                          onPressed: () {
                            _launchGoogleMapsDirections(context, place);
                          },
                        ),
                      ],
                    ),
                  ),
                )).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Nuevo método para abrir Google Maps con una ubicación específica
  void _launchGoogleMaps(BuildContext context, Place place) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=${place.latitude},${place.longitude}';
    Uri uri = Uri.parse(googleUrl);
    
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        throw 'No se pudo abrir Google Maps';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al abrir el mapa: $e')),
      );
    }
  }

  // Nuevo método para obtener indicaciones en Google Maps
  void _launchGoogleMapsDirections(BuildContext context, Place place) async {
    String googleUrl = 'https://www.google.com/maps/dir/?api=1&destination=${place.latitude},${place.longitude}&travelmode=driving';
    Uri uri = Uri.parse(googleUrl);
    
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        throw 'No se pudo abrir Google Maps';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al obtener indicaciones: $e')),
      );
    }
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
  final double? latitude;
  final double? longitude;
  final String address;
  final String? mapUrl;

  Place({
    required this.name,
    this.latitude,
    this.longitude,
    required this.address,
    this.mapUrl,
  });
}
