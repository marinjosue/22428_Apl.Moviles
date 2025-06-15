package com.miempresa.pedidos.repository;

import com.miempresa.pedidos.model.DetallePedido;
import org.springframework.data.jpa.repository.JpaRepository;

public interface DetallePedidoRepository extends JpaRepository<DetallePedido, Long> {}