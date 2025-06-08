# Firework Together - Project Action Plan

## Project Overview
A real-time collaborative web application where multiple users can click anywhere on the screen to create firework explosions that are synchronized and visible to all connected users. Built with Phoenix LiveView to evaluate real-time synchronization and animation performance across clients.

## Core Objectives
- Evaluate Phoenix LiveView's real-time capabilities
- Test animation synchronization across multiple clients
- Explore PubSub broadcasting performance
- Create a fun, interactive collaborative experience

## Getting Started

### Project Setup
```bash
mix phx.new firework_together --live --no-ecto
cd firework_together
mix deps.get
mix phx.server
```

## Technical Requirements

### Functional Requirements
- [ ] Users can click anywhere on the screen to trigger fireworks
- [ ] All connected users see the same fireworks in real-time
- [ ] No authentication required (anonymous users)
- [ ] Fireworks appear at exact click coordinates for all users
- [ ] Multiple simultaneous fireworks supported
- [ ] Automatic cleanup of expired fireworks

### Non-Functional Requirements
- [ ] Minimal latency between click and firework appearance
- [ ] Smooth animations across different browsers
- [ ] Support for 5-10 concurrent users (initial target)
- [ ] Responsive design (works on mobile/desktop)

## Technical Architecture

### Backend (Phoenix/Elixir)
- Phoenix LiveView for real-time UI updates
- Phoenix PubSub for broadcasting events
- GenServer for managing firework state
- Minimal REST endpoints (health check only)

### Frontend
- Phoenix LiveView templates
- CSS animations for firework effects
- Minimal JavaScript for click handling
- TailwindCSS for styling

### Data Structure
```elixir
%Firework{
  id: UUID,
  x: integer,
  y: integer, 
  color: string,
  created_at: timestamp,
  duration: integer
}
```

## Development Phases

### Phase 1: Project Setup ✅ COMPLETED
- [x] Create new Phoenix project with LiveView
- [x] Configure PubSub 
- [x] Set up basic routing and LiveView
- [x] Add TailwindCSS configuration
- [x] Create basic HTML template with click area
- [x] Add Tidewave integration for development assistance
- [x] Implement JavaScript hooks for click coordinate capture
- [x] Create basic CSS animations for firework effects
- [x] Set up GitHub repository and initial commit

### Phase 2: Core Functionality  
- [ ] Implement click event handling in LiveView
- [ ] Create firework state management
- [ ] Add PubSub broadcasting
- [ ] Implement basic firework rendering
- [ ] Add firework cleanup/expiration

### Phase 3: Animation & Styling
- [ ] Design CSS firework animations
- [ ] Add multiple firework colors/styles
- [ ] Implement responsive design
- [ ] Add visual feedback for clicks
- [ ] Optimize animation performance

### Phase 4: Real-time Synchronization
- [ ] Add server timestamps for sync
- [ ] Handle late-joining users
- [ ] Implement rate limiting
- [ ] Add connection status indicators
- [ ] Test with multiple concurrent users

### Phase 5: Polish & Testing
- [ ] Add error handling and reconnection
- [ ] Performance testing and optimization
- [ ] Cross-browser testing
- [ ] Mobile responsiveness testing
- [ ] Deploy to production environment

## File Structure
```
firework_together/
├── lib/
│   ├── firework_together/
│   │   ├── application.ex
│   │   ├── firework.ex
│   │   └── firework_manager.ex
│   ├── firework_together_web/
│   │   ├── components/
│   │   ├── live/
│   │   │   └── firework_live.ex
│   │   ├── router.ex
│   │   └── endpoint.ex
│   └── firework_together.ex
├── assets/
│   ├── css/
│   │   ├── app.css
│   │   └── fireworks.css
│   └── js/
│       └── app.js
├── config/
└── test/
```

## Key Implementation Details

### LiveView Event Handling
```elixir
def handle_event("create_firework", %{"x" => x, "y" => y}, socket) do
  firework = create_firework(x, y)
  Phoenix.PubSub.broadcast(FireworkTogether.PubSub, "fireworks", {:new_firework, firework})
  {:noreply, socket}
end
```

### PubSub Integration
```elixir
def handle_info({:new_firework, firework}, socket) do
  {:noreply, assign(socket, :fireworks, [firework | socket.assigns.fireworks])}
end
```

### Animation Strategy
- CSS keyframe animations for performance
- JavaScript for precise timing if needed
- SVG or Canvas for complex effects (Phase 2+)

## Testing Strategy
- Unit tests for firework logic
- Integration tests for PubSub broadcasting  
- Browser testing for animations
- Load testing with multiple concurrent users
- Network latency simulation

## Performance Considerations
- Rate limiting: max 5 clicks per second per user
- State cleanup: remove fireworks after 3 seconds
- Memory management: limit to 50 active fireworks max
- Connection monitoring and automatic reconnection

## Success Metrics
- Fireworks appear within 100ms of click across all clients
- Support for 10+ concurrent users without performance degradation
- Smooth animations at 60fps
- Less than 1% message loss in PubSub broadcasting
- Sub-second page load times

## Future Enhancements (Out of Scope)
- User avatars/cursors
- Firework patterns and shapes
- Sound effects
- Persistence/replay functionality
- Room-based sessions
- Mobile app version

## Technical Risks & Mitigations
- **Animation sync across browsers**: Test early, use CSS transforms
- **PubSub message ordering**: Add sequence numbers if needed  
- **Memory leaks from state**: Implement aggressive cleanup
- **Network partitions**: Add reconnection logic
- **Rate limiting bypass**: Server-side validation

---

## Next Steps
1. Start with Phase 1: Project Setup
2. Create basic Phoenix LiveView application
3. Implement simple click handling
4. Add basic firework rendering
5. Test with multiple browser tabs locally