module Api
  class JogosController < ApplicationController
    def index
      jogos = Jogo.all
      render json: jogos
    end

    def show
      jogo = Jogo.find(params[:id])
      render json: jogo
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Jogo não encontrado" }, status: :not_found
    end

    def create
      jogo = Jogo.new(jogo_params)
      if jogo.save
        begin
          $queue.publish(jogo.to_json, persistent: true)
          Rails.logger.info "Jogo enviado para RabbitMQ: #{jogo.titulo}"
        rescue StandardError => e
          Rails.logger.error "Erro ao enviar para RabbitMQ: #{e.message}"
        end

        render json: jogo, status: :created
      else
        render json: jogo.errors, status: :unprocessable_entity
      end
    end

    def update
      jogo = Jogo.find(params[:id])
      if jogo.update(jogo_params)
        render json: jogo
      else
        render json: jogo.errors, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Jogo não encontrado" }, status: :not_found
    end

    def destroy
      jogo = Jogo.find(params[:id])
      jogo.destroy
      head :no_content
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Jogo não encontrado" }, status: :not_found
    end

    private

    def jogo_params
      params.permit(:titulo, :midia, :preco, :estoque)
    end
  end
end
