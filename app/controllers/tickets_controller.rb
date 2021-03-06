class TicketsController < ApplicationController
  before_action :authenticate_user!
  before_filter :set_event
  before_filter :set_ticket, except: [:new, :create]

  # DELETE /events/:event_id/tickets/:id
  # TODO: Add actions on destruction.
  def destroy
    @ticket.destroy unless @ticket.nil?
    render nothing: true, status: :moved_permanently
  end

  # GET /events/:event_id/tickets/new
  def new
    @ticket = @event.tickets.build({ 
      price: 0,
      date_start: @event.date_start,
      date_end: @event.date_end
    })

    respond_to do | format |
      format.html { render layout: nil }
    end
  end

  # GET /events/:event_id/tickets/:id/edit
  def edit
    respond_to do | format |
      format.html { render layout: nil }
    end
  end

  # GET /events/:event_id/tickets/:id
  def show
    respond_to do | format |
      if @ticket.nil?
        format.html
        format.js { render jbuilder: nil }
        format.json { render nothing: true }
      else
        format.js { render jbuilder: @ticket }
        format.json { render nothing: true }
        format.html { redirect_to root_url, notice: 'No ticket was found :(' }
      end
    end
  end

  # PUT /events/:event_id/tickets/:id
  def create
    @ticket = Ticket.create! ticket_params
    @ticket.event = @event

    respond_to do | format |
      if @ticket.save
        format.html { 
          redirect_to @event,
          notice: 'Ticket was successfully created.',
          status: 200
        }
        format.json {
          render action: :show,
          status: 200 
        }
        format.js { 
          render action: :show,
          status: 200
        }
      else
        format.html { render action: :new }
        format.json { render json: @ticket.errors, status: 500 }
        format.js   { render json: @ticket.errors, status: 500 }
      end
    end
  end

  # POST /events/:event-id/tickets/:id
  def update 
    @ticket.update_attributes ticket_params 
    @ticket.event = @event

    respond_to do | format |
      if @ticket.save
        format.html { 
          redirect_to @ticket,
          notice: 'Ticket was successfully updated.'
        }
        format.json {
          render action: :show,
          location: tickets_url(@ticket)
        }
        format.js { render action: :show }
      else
        format.html { redirect_to @ticket, notice: @ticket.errors, status: 500 }
        format.json { render json: @ticket.errors, status: 500 } 
        format.js   { render json: @ticket.errors, status: 500 }
      end
    end
  end

  private
    def set_event
      @event = Event.find params[:event_id]
      Rails.logger.info 'No event passed!' unless params.include? :event_id
    end

    def set_ticket
      @ticket = Ticket.find params[:id]
      Rails.logger.info 'No ticket passed!' unless params.include? :id
    end

    def ticket_params
      params.require(:ticket).permit(:name, :description,
         :date_start, :date_end, :quantity, :price)
    end
end
