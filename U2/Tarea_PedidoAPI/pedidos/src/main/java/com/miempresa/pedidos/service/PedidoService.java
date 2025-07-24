package com.miempresa.pedidos.service;

import com.miempresa.pedidos.dto.DetallePedidoDTO;
import com.miempresa.pedidos.dto.PedidoDTO;
import com.miempresa.pedidos.model.DetallePedido;
import com.miempresa.pedidos.model.Pedido;
import com.miempresa.pedidos.repository.PedidoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class PedidoService {

    @Autowired
    private PedidoRepository pedidoRepository;

    public PedidoDTO crearPedido(PedidoDTO dto) {
        Pedido pedido = new Pedido();
        pedido.setCliente(dto.getCliente());
        pedido.setFecha(dto.getFecha());
        return mapToDTO(pedidoRepository.save(pedido));
    }

    public PedidoDTO agregarDetalle(Long pedidoId, DetallePedidoDTO dto) {
        Pedido pedido = pedidoRepository.findById(pedidoId).orElseThrow();
        DetallePedido detalle = new DetallePedido();
        detalle.setProducto(dto.getProducto());
        detalle.setCantidad(dto.getCantidad());
        detalle.setPrecio(dto.getPrecio());
        detalle.setPedido(pedido);
        pedido.getDetalles().add(detalle);
        return mapToDTO(pedidoRepository.save(pedido));
    }

    public List<PedidoDTO> obtenerTodos() {
        return pedidoRepository.findAll().stream()
                .map(this::mapToDTO)
                .collect(Collectors.toList());
    }

    public PedidoDTO obtenerPorId(Long id) {
        return mapToDTO(pedidoRepository.findById(id).orElseThrow());
    }

    private PedidoDTO mapToDTO(Pedido pedido) {
        PedidoDTO dto = new PedidoDTO();
        dto.setId(pedido.getId());
        dto.setCliente(pedido.getCliente());
        dto.setFecha(pedido.getFecha());
        dto.setDetalles(pedido.getDetalles().stream()
                .map(this::mapDetalleToDTO)
                .collect(Collectors.toList()));
        return dto;
    }

    private DetallePedidoDTO mapDetalleToDTO(DetallePedido detalle) {
        DetallePedidoDTO dto = new DetallePedidoDTO();
        dto.setId(detalle.getId());
        dto.setProducto(detalle.getProducto());
        dto.setCantidad(detalle.getCantidad());
        dto.setPrecio(detalle.getPrecio());
        return dto;
    }
}