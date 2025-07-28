package com.example.bdd_dto.service;

import com.example.bdd_dto.model.Usuario;
import com.example.bdd_dto.repository.UsuarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class UsuarioServicio {

    @Autowired
    private UsuarioRepository usuarioRepository;

    public Usuario registrarUsuario(Usuario usuario) {
        Optional<Usuario> existente = usuarioRepository.findByUsername(usuario.getUsername());
        if (existente.isPresent()) {
            throw new RuntimeException("El nombre de usuario ya está en uso");
        }
        return usuarioRepository.save(usuario);
    }

    public Usuario login(String username, String password) {
        Optional<Usuario> usuario = usuarioRepository.findByUsername(username);
        if (usuario.isPresent() && usuario.get().getPassword().equals(password)) {
            return usuario.get();
        } else {
            throw new RuntimeException("Credenciales inválidas");
        }
    }
}
