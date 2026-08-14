locals {
  
  vpc_name                 = "${var.project_name}-${var.environment}-vpc"
  public_subnet_name_a     = "${var.project_name}-${var.environment}-public-a"
  public_subnet_name_b     = "${var.project_name}-${var.environment}-public-b"
  private_subnet_name_a    = "${var.project_name}-${var.environment}-private-a"
  private_subnet_name_b    = "${var.project_name}-${var.environment}-private-b"
  internet_gateway_name    = "${var.project_name}-${var.environment}-igw"
  nat_ip_name              = "${var.project_name}-${var.environment}-nat-eip"
  nat_gateway_name         = "${var.project_name}-${var.environment}-nat"
  route_table_name         = "${var.project_name}-${var.environment}-public-rt"
  private_route_table_name = "${var.project_name}-${var.environment}-private-rt"
}