import 'package:flutter/material.dart';
import '../../services/request_service.dart';
import '../../models/request_model.dart';

class AdminDashboardScreen extends StatefulWidget {
  // Fixed: Using super.key parameter
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final RequestService _requestService = RequestService();
  List<AidRequest> _requests = [];
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadRequests();
  }
  
  Future<void> _loadRequests() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Fixed: Properly await the Future
      final requests = await _requestService.getRequests();
      setState(() {
        _requests = requests;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading requests: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  Widget _buildStatusSummary() {
    int pendingCount = _requests.where((r) => r.status == 'pending').length;
    int inProgressCount = _requests.where((r) => r.status == 'in-progress').length;
    int completedCount = _requests.where((r) => r.status == 'completed').length;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatusCard('Pending', pendingCount, Colors.orange),
        _buildStatusCard('In Progress', inProgressCount, Colors.blue),
        _buildStatusCard('Completed', completedCount, Colors.green),
      ],
    );
  }
  
  Widget _buildStatusCard(String title, int count, Color color) {
    return Expanded(
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadRequests,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Request Status Summary',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      _buildStatusSummary(),
                      
                      const SizedBox(height: 24),
                      
                      const Text(
                        'Recent Requests',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _requests.length > 5 ? 5 : _requests.length,
                        itemBuilder: (context, index) {
                          final request = _requests[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              title: Text(request.requestType),
                              subtitle: Text(
                                '${request.name} - ${request.address}\nStatus: ${request.status}',
                              ),
                              trailing: Icon(
                                Icons.circle,
                                color: request.status == 'pending'
                                    ? Colors.orange
                                    : request.status == 'in-progress'
                                        ? Colors.blue
                                        : Colors.green,
                                size: 12,
                              ),
                              onTap: () {
                                // Navigate to request details
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}