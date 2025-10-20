require 'bunny'

begin
  # Conecta ao RabbitMQ
  $rabbitmq_connection = Bunny.new(hostname: 'localhost')
  $rabbitmq_connection.start

  # Cria canal
  $rabbitmq_channel = $rabbitmq_connection.create_channel

  # Cria fila
  $queue = $rabbitmq_channel.queue('jogos_queue', durable: true)

  Rails.logger.info "RabbitMQ conectado e fila criada com sucesso!"
rescue Bunny::TCPConnectionFailed => e
  Rails.logger.error "Falha ao conectar RabbitMQ: #{e.message}"
end
