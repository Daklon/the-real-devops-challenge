resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_subnet" "private" {
  for_each = var.subnets.private

  vpc_id            = aws_vpc.main.id
  availability_zone = each.value["az"]
  cidr_block        = each.value["cidr"]
}

resource "aws_route_table" "private" {
  for_each = var.subnets.private

  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[each.key].id
  }
}

resource "aws_route_table_association" "private" {
  for_each = var.subnets.private

  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private[each.key].id
}

resource "aws_subnet" "public" {
  for_each = var.subnets.public

  vpc_id            = aws_vpc.main.id
  availability_zone = each.value["az"]
  cidr_block        = each.value["cidr"]
}

resource "aws_route_table" "public" {
  for_each = var.subnets.public

  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table_association" "public" {
  for_each = var.subnets.public

  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public[each.key].id
}

resource "aws_eip" "nat" {
  for_each = var.subnets.public

  domain = "vpc"
}

resource "aws_nat_gateway" "main" {
  for_each = var.subnets.public

  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.public[each.key].id

  depends_on = [aws_internet_gateway.main]
}
