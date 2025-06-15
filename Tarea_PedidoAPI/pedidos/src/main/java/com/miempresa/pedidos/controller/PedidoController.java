package com.miempresa.pedidos.controller;

import com.miempresa.pedidos.dto.DetallePedidoDTO;
import com.miempresa.pedidos.dto.PedidoDTO;
import com.miempresa.pedidos.service.PedidoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/pedidos")
public class PedidoController {

    @Autowired
    private PedidoService pedidoService;

    @PostMapping
    public ResponseEntity<PedidoDTO> crearPedido(@RequestBody PedidoDTO dto) {
        return ResponseEntity.ok(pedidoService.crearPedido(dto));
    }

    @PostMapping("/{id}/detalles")
    public ResponseEntity<PedidoDTO> agregarDetalle(@PathVariable Long id, @RequestBody DetallePedidoDTO dto) {
        return ResponseEntity.ok(pedidoService.agregarDetalle(id, dto));
    }

    @GetMapping
    public ResponseEntity<List<PedidoDTO>> listarPedidos() {
        return ResponseEntity.ok(pedidoService.obtenerTodos());
    }

    @GetMapping("/{id}")
    public ResponseEntity<PedidoDTO> obtenerPedido(@PathVariable Long id) {
        return ResponseEntity.ok(pedidoService.obtenerPorId(id));
    }
}