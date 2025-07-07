const express = require('express');
const cors = require('cors');
const { MongoClient, ObjectId } = require('mongodb');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors({ origin: true, credentials: true }));
app.use(express.json());

const mongoUrl = process.env.MONGODB_URI;
let cachedClient = null;
let cachedDb = null;

async function getDb() {
  if (cachedDb) return cachedDb;
  const client = await MongoClient.connect(mongoUrl, { useUnifiedTopology: true });
  cachedClient = client;
  cachedDb = client.db();
  return cachedDb;
}

// RUTAS DE USUARIOS
const bcrypt = require('bcrypt');

app.post('/register', async (req, res) => {
  try {
    const db = await getDb();
    const { uid, name, email, password, photoUrl } = req.body;

    const existing = await db.collection('usuarios').findOne({ uid });
    if (existing) {
      return res.status(400).json({ error: 'Usuario ya existe' });
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    const user = {
      uid,
      name,
      email,
      photoUrl: photoUrl || '',
      password: hashedPassword,
      favoritos: [],
      fechaRegistro: new Date(),
      ultimaActividad: new Date()
    };

    await db.collection('usuarios').insertOne(user);

    res.status(201).json({ message: 'Usuario registrado exitosamente' });
  } catch (error) {
    console.error('Error en /register:', error);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
});
app.post('/login', async (req, res) => {
  try {
    const db = await getDb();
    const { uid, password } = req.body;

    const user = await db.collection('usuarios').findOne({ uid });

    if (!user) {
      return res.status(404).json({ error: 'Usuario no encontrado' });
    }

    const match = await bcrypt.compare(password, user.password);
    if (!match) {
      return res.status(401).json({ error: 'Contraseña incorrecta' });
    }

    await db.collection('usuarios').updateOne(
      { uid },
      { $set: { ultimaActividad: new Date() } }
    );

    const { password: _, ...userSinPassword } = user; // remover la clave
    res.json({ user: userSinPassword });
  } catch (error) {
    console.error('Error en /login:', error);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
});

// Crear o actualizar perfil de usuario
app.post('/user', async (req, res) => {
  try {
    const db = await getDb();
    const { uid, name, email, photoUrl } = req.body;
    const user = {
      uid,
      name,
      email,
      photoUrl: photoUrl || '',
      favoritos: [],
      ultimaActividad: new Date()
    };

    await db.collection('usuarios').updateOne(
      { uid },
      { 
        $set: user,
        $setOnInsert: { fechaRegistro: new Date() }
      },
      { upsert: true }
    );

    res.status(200).json({ message: 'Usuario creado/actualizado exitosamente' });
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: error.message || 'Error interno del servidor' });
  }
});

// Obtener perfil de usuario
app.get('/user/:uid', async (req, res) => {
  try {
    const db = await getDb();
    const { uid } = req.params;
    const user = await db.collection('usuarios').findOne({ uid });
    
    if (!user) {
      return res.status(404).json({ error: 'Usuario no encontrado' });
    }

    res.json(user);
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
});

// Agregar sitio a favoritos
app.post('/user/:uid/favoritos', async (req, res) => {
  try {
    const db = await getDb();
    const { uid } = req.params;
    const { sitioId } = req.body;

    await db.collection('usuarios').updateOne(
      { uid },
      { 
        $addToSet: { favoritos: sitioId },
        $set: { ultimaActividad: new Date() }
      }
    );

    res.status(200).json({ message: 'Sitio agregado a favoritos' });
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
});

// Eliminar sitio de favoritos
app.delete('/user/:uid/favoritos', async (req, res) => {
  try {
    const db = await getDb();
    const { uid } = req.params;
    const { sitioId } = req.body;

    await db.collection('usuarios').updateOne(
      { uid },
      { 
        $pull: { favoritos: sitioId },
        $set: { ultimaActividad: new Date() }
      }
    );

    res.status(200).json({ message: 'Sitio eliminado de favoritos' });
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
});

// Obtener favoritos del usuario
app.get('/user/:uid/favoritos', async (req, res) => {
  try {
    const db = await getDb();
    const { uid } = req.params;
    const user = await db.collection('usuarios').findOne({ uid });
    
    res.json({ favoritos: user?.favoritos || [] });
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
});

// RUTAS DE COMENTARIOS

// Crear comentario
app.post('/comentarios', async (req, res) => {
  try {
    const db = await getDb();
    const { sitioId, usuarioId, nombreUsuario, texto, calificacion } = req.body;
    
    const comentario = {
      sitioId,
      usuarioId,
      nombreUsuario,
      texto,
      calificacion: parseFloat(calificacion),
      fecha: new Date()
    };

    const result = await db.collection('comentarios').insertOne(comentario);
    res.status(201).json({ id: result.insertedId, message: 'Comentario creado exitosamente' });
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
});

// Obtener comentarios por sitio
app.get('/comentarios/sitio/:sitioId', async (req, res) => {
  try {
    const db = await getDb();
    const { sitioId } = req.params;
    const comentarios = await db.collection('comentarios')
      .find({ sitioId })
      .sort({ fecha: -1 })
      .toArray();

    res.json(comentarios);
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
});

// Obtener comentarios por usuario
app.get('/comentarios/usuario/:usuarioId', async (req, res) => {
  try {
    const db = await getDb();
    const { usuarioId } = req.params;
    const comentarios = await db.collection('comentarios')
      .find({ usuarioId })
      .sort({ fecha: -1 })
      .toArray();

    res.json(comentarios);
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
});

// Actualizar comentario
app.put('/comentarios/:id', async (req, res) => {
  try {
    const db = await getDb();
    const { id } = req.params;
    const { texto, calificacion } = req.body;

    await db.collection('comentarios').updateOne(
      { _id: new ObjectId(id) },
      { 
        $set: { 
          texto, 
          calificacion: parseFloat(calificacion),
          fechaModificacion: new Date()
        }
      }
    );

    res.status(200).json({ message: 'Comentario actualizado exitosamente' });
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
});

// Eliminar comentario
app.delete('/comentarios/:id', async (req, res) => {
  try {
    const db = await getDb();
    const { id } = req.params;
    await db.collection('comentarios').deleteOne({ _id: new ObjectId(id) });
    
    res.status(200).json({ message: 'Comentario eliminado exitosamente' });
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
});

// Obtener calificación promedio de un sitio
app.get('/comentarios/sitio/:sitioId/promedio', async (req, res) => {
  try {
    const db = await getDb();
    const { sitioId } = req.params;
    const result = await db.collection('comentarios').aggregate([
      { $match: { sitioId } },
      { $group: { _id: null, promedio: { $avg: '$calificacion' }, total: { $sum: 1 } } }
    ]).toArray();

    const promedio = result.length > 0 ? result[0].promedio : 0;
    const total = result.length > 0 ? result[0].total : 0;

    res.json({ promedio: promedio.toFixed(1), total });
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
});

// RUTAS DE SITIOS TURÍSTICOS

// Obtener todos los sitios turísticos
app.get('/sitios', async (req, res) => {
  try {
    const db = await getDb();
    const sitios = await db.collection('sitios_turisticos').find({}).toArray();
    res.json(sitios);
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
});

// Obtener sitio por ID
app.get('/sitios/:id', async (req, res) => {
  try {
    const db = await getDb();
    const { id } = req.params;
    const sitio = await db.collection('sitios_turisticos').findOne({ _id: new ObjectId(id) });
    
    if (!sitio) {
      return res.status(404).json({ error: 'Sitio no encontrado' });
    }

    res.json(sitio);
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
});

// Crear sitio turístico (para administradores)
app.post('/sitios', async (req, res) => {
  try {
    const db = await getDb();
    const { nombre, descripcion, latitud, longitud, categoria, imagenes } = req.body;
    
    const sitio = {
      nombre,
      descripcion,
      latitud: parseFloat(latitud),
      longitud: parseFloat(longitud),
      categoria: categoria || 'general',
      imagenes: imagenes || [],
      fechaCreacion: new Date()
    };

    const result = await db.collection('sitios_turisticos').insertOne(sitio);
    res.status(201).json({ id: result.insertedId, message: 'Sitio creado exitosamente' });
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
});

// Inicializar datos de ejemplo
app.post('/init-data', async (req, res) => {
  try {
    const db = await getDb();
    // Verificar si ya existen sitios
    const existingSites = await db.collection('sitios_turisticos').countDocuments();
    
    if (existingSites === 0) {
      const sitiosEjemplo = [
        {
          nombre: 'Mitad del Mundo',
          descripcion: 'Monumento icónico de Ecuador ubicado en la línea ecuatorial.',
          latitud: -0.002789,
          longitud: -78.455833,
          categoria: 'monumento',
          imagenes: [],
          fechaCreacion: new Date()
        },
        {
          nombre: 'Centro Histórico de Quito',
          descripcion: 'Patrimonio cultural de la humanidad con arquitectura colonial.',
          latitud: -0.2201641,
          longitud: -78.5123274,
          categoria: 'historico',
          imagenes: [],
          fechaCreacion: new Date()
        },
        {
          nombre: 'Teleférico Quito',
          descripcion: 'Vista panorámica de la ciudad desde las alturas.',
          latitud: -0.1807,
          longitud: -78.5158,
          categoria: 'entretenimiento',
          imagenes: [],
          fechaCreacion: new Date()
        }
      ];

      await db.collection('sitios_turisticos').insertMany(sitiosEjemplo);
      res.json({ message: 'Datos de ejemplo insertados exitosamente' });
    } else {
      res.json({ message: 'Los datos ya existen' });
    }
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
});

// Ruta de health check
app.get('/health', (req, res) => {
  res.json({ status: 'OK', message: 'Servidor funcionando correctamente' });
});

if (process.env.VERCEL !== '1') {
  app.listen(PORT, () => {
    console.log(`Servidor ejecutándose en puerto ${PORT}`);
  });
}

module.exports = app;