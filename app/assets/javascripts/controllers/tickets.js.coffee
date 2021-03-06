#= require lib/core

Portcullis.Tickets =
  bind: ->
    setTimeout ->
      self.updateTicketClasses()
    , 1000

  validateTicket: (ticket) ->
    order_field = ticket.find('input[data-ticket=quantity]')
    order_count = parseInt(order_field.val())
    max_size = Number.POSITIVE_INFINITY
    max_size = parseInt(order_field.attr('max')) if order_field.is('[max]')
    min_size = parseInt(order_field.attr('min'))
    min_size <= order_count and order_count <= max_size

  obtainTimeRange: (ticket) ->
    date_start = Date.parse(ticket.attr('data-ticket-start'))
    date_end = Date.parse(ticket.attr('data-ticket-end'))
    date_now = new Date
    is_in_future = date_start > date_now
    is_in_past = date_end < date_now
    {
      is_future:   is_in_future
      is_past:     is_in_past
      is_current:  !is_in_past && !is_in_future
    }

  updateTicketClasses: ->
    tickets = $('li[data-ticket-id]')
    tickets.each (index, ticket) =>
      ticket = $(ticket)
      self.updateTimeSenstiveClasses ticket

  updateTimeSenstiveClasses : (ticket) ->
    ticket.removeClass 'current past future'
    time_range = self.obtainTimeRange(ticket)
    ticket.addClass 'current' if time_range.is_current
    ticket.addClass 'past' if time_range.is_past
    ticket.addClass 'future' if time_range.is_future


self = Portcullis.Tickets

Portcullis.bind 'boot', ->
  Portcullis.Tickets.bind()
