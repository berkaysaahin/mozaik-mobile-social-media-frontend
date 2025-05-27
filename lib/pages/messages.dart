import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mozaik/app_colors.dart';
import 'package:mozaik/blocs/auth_bloc.dart';
import 'package:mozaik/blocs/conversation_bloc.dart';
import 'package:mozaik/components/message.dart';
import 'package:mozaik/components/search_bar.dart';
import 'package:mozaik/events/conversation_event.dart';
import 'package:mozaik/states/auth_state.dart';
import 'package:mozaik/states/conversation_state.dart';

class MessagesPage extends StatelessWidget {
  final String? initialConversationId;
  const MessagesPage({super.key, this.initialConversationId});

  @override
  Widget build(BuildContext context) {
    final userId = context.select((AuthBloc bloc) {
      if (bloc.state is Authenticated) {
        return (bloc.state as Authenticated).user.userId;
      }
      return null;
    });
    if (userId != null) {
      context.read<ConversationBloc>().add(LoadConversations(userId));
    }

    return BlocConsumer<ConversationBloc, ConversationState>(
      listener: (context, state) {
        if (state is ConversationLoadFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Failed to load conversations: ${state.error}')),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: RefreshIndicator(
            onRefresh: () async {
              context.read<ConversationBloc>().add(LoadConversations(userId!));
            },
            child: _buildBody(state, context, userId),
          ),
        );
      },
    );
  }

  Widget _buildBody(
      ConversationState state, BuildContext context, String? userId) {
    if (state is ConversationLoadSuccess) {
      if (state.conversations.isEmpty) {
        return _buildEmptyState();
      }
      return _buildConversationList(state, userId);
    } else if (state is ConversationLoadFailure) {
      return _buildErrorState(state, context, userId);
    }
    return _buildLoadingState();
  }

  Widget _buildConversationList(ConversationLoadSuccess state, String? userId) {
    if (userId == null) {
      return Center(child: Text("User ID is null"));
    }
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          sliver: SliverToBoxAdapter(
            child: CustomSearchBar(
              hintText: "Search in messages",
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final conv = state.conversations[index];
              return MessageComponent(
                currentUserId: userId,
                conversationId: conv.id,
                recipientName: conv.getOtherParticipantUsername(userId),
                recipientHandle: conv.getOtherParticipantHandle(userId),
                recipientAvatar: conv.getOtherParticipantProfilePicture(userId),
                lastMessage: conv.lastMessage ?? 'No messages yet',
                lastMessageTime: conv.formattedLastMessageTime,
              );
            },
            childCount: state.conversations.length,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: const ShimmerLoadingBox(height: 80),
        );
      },
    );
  }

  Widget _buildErrorState(
      ConversationLoadFailure state, BuildContext context, String? userId) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Failed to load conversations',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            state.error,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: userId != null
                ? () => context
                    .read<ConversationBloc>()
                    .add(LoadConversations(userId))
                : null,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.forum_outlined, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No conversations yet',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Start a new conversation by connecting with other users',
            style: TextStyle(color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class ShimmerLoadingBox extends StatelessWidget {
  final double height;

  const ShimmerLoadingBox({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.grey[200]
            : Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
