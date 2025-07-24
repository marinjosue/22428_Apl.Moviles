package com.miempresa.pedidos.repository;

import com.miempresa.pedidos.model.Pedido;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PedidoRepository extends JpaRepository<Pedido, Long> {}
