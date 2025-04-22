abstract class UserEvent {}

class UpdateLastSeen extends UserEvent {
  final String userId;

  UpdateLastSeen({required this.userId});
}
