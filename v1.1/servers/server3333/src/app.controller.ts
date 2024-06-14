import { Controller, Get } from '@nestjs/common';
import { AppService } from './app.service';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get()
  getHello(): string {
    return 'hello from 3333';
  }

  @Get('app1')
  getApp1(): string {
    return 'app1 from 3333';
  }

  @Get('app2')
  getApp2(): string {
    return 'app2 from 3333';
  }

  @Get('page1')
  getPage1(): string {
    return 'page1 from 3333';
  }

  @Get('admin')
  getAdmin(): string {
    return 'admin from 3333';
  }
}
